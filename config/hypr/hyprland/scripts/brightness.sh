#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR

lockfile=/tmp/brightness.lock
if [ -f "$lockfile" ]; then
    echo "Script already running"
    exit 1
fi
touch "$lockfile"
trap "rm -f '$lockfile'; exit" INT TERM EXIT

theme=Papirus-Dark

# Get all ddcci backlight devices
get_devices() {
    brightnessctl --list 2>/dev/null | grep -oP "'ddcci\K[^']*" | sed 's/^/ddcci/'
}

# Get current brightness percentage from first device
get_brightness() {
    local dev="$1"
    local current max
    current=$(brightnessctl -d "$dev" get)
    max=$(brightnessctl -d "$dev" max)
    echo $(( current * 100 / max ))
}

send_notification() {
    local brightness="$1"

    if [ "$brightness" -lt 10 ]; then
        icon_name="$HOME/.icons/$theme/16x16/symbolic/status/display-brightness-off-symbolic.svg"
    elif [ "$brightness" -lt 30 ]; then
        icon_name="$HOME/.icons/$theme/16x16/symbolic/status/display-brightness-low-symbolic.svg"
    elif [ "$brightness" -lt 70 ]; then
        icon_name="$HOME/.icons/$theme/16x16/symbolic/status/display-brightness-medium-symbolic.svg"
    else
        icon_name="$HOME/.icons/$theme/16x16/symbolic/status/display-brightness-high-symbolic.svg"
    fi

    if [ ! -f "$icon_name" ]; then
        icon_name="display-brightness-symbolic"
    fi

    bar=$(seq -s "━" $(( brightness / 5 )) | sed 's/[0-9]//g')

    notify-send --app-name brightness \
        -h string:x-canonical-private-synchronous:osd \
        -i "$icon_name" \
        "$brightness%" \
        "$bar"
}

mapfile -t DEVICES < <(get_devices)

if [ ${#DEVICES[@]} -eq 0 ]; then
    echo "No ddcci backlight devices found"
    exit 1
fi

case "$1" in
    up)
        if [ -z "${2:-}" ]; then
            echo "Usage: $0 up <0-100>"
            exit 1
        fi
        for dev in "${DEVICES[@]}"; do
            brightnessctl -d "$dev" set "$2%+" &
        done
        wait
        send_notification "$(get_brightness "${DEVICES[0]}")"
        ;;
    down)
        if [ -z "${2:-}" ]; then
            echo "Usage: $0 down <0-100>"
            exit 1
        fi
        for dev in "${DEVICES[@]}"; do
            brightnessctl -d "$dev" set "$2%-" &
        done
        wait
        send_notification "$(get_brightness "${DEVICES[0]}")"
        ;;
    set)
        if [ -z "${2:-}" ]; then
            echo "Usage: $0 set <0-100>"
            exit 1
        fi
        get_brightness "${DEVICES[0]}" > ~/.cache/brightness
        for dev in "${DEVICES[@]}"; do
            brightnessctl -d "$dev" set "$2%" &
        done
        wait
        send_notification "$2"
        ;;
    revert)
        if [ -f ~/.cache/brightness ]; then
            saved=$(cat ~/.cache/brightness)
            for dev in "${DEVICES[@]}"; do
                brightnessctl -d "$dev" set "$saved%" &
            done
            wait
            send_notification "$saved"
        else
            echo "No saved brightness found"
            exit 1
        fi
        ;;
    get)
        for dev in "${DEVICES[@]}"; do
            echo "$dev: $(get_brightness "$dev")%"
        done
        ;;
    list)
        echo "Detected backlight devices:"
        brightnessctl --list
        ;;
    *)
        echo "Usage: $0 {up <value>|down <value>|set <value>|revert|get|list}"
        exit 1
        ;;
esac
