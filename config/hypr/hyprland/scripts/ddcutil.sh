#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR

lockfile=/tmp/ddcutil.lock
if [ -f "$lockfile" ]; then
    echo "Script already running"
    exit 1
fi
touch "$lockfile"
trap "rm -f '$lockfile'; exit" INT TERM EXIT

theme=Papirus-Dark

# Get all I2C bus numbers from ddcutil
get_buses() {
    ddcutil detect --brief 2>/dev/null | grep -oP '/dev/i2c-\K\d+'
}

# Get current brightness from first monitor
get_brightness() {
    local bus="$1"
    ddcutil --bus "$bus" getvcp 10 2>/dev/null | grep -oP 'current value =\s+\K\d+'
}

send_notification() {
    local brightness="$1"

    # Determine icon based on brightness level
    if [ "$brightness" -lt 10 ]; then
        icon_name="$HOME/.icons/$theme/16x16/symbolic/status/display-brightness-off-symbolic.svg"
    elif [ "$brightness" -lt 30 ]; then
        icon_name="$HOME/.icons/$theme/16x16/symbolic/status/display-brightness-low-symbolic.svg"
    elif [ "$brightness" -lt 70 ]; then
        icon_name="$HOME/.icons/$theme/16x16/symbolic/status/display-brightness-medium-symbolic.svg"
    else
        icon_name="$HOME/.icons/$theme/16x16/symbolic/status/display-brightness-high-symbolic.svg"
    fi

    # Fallback to generic icon if theme icons don't exist
    if [ ! -f "$icon_name" ]; then
        icon_name="display-brightness-symbolic"
    fi

    # Create progress bar (━ character)
    bar=$(seq -s "━" $(($brightness/5)) | sed 's/[0-9]//g')

    # Send notification
    notify-send --app-name brightness \
        -h string:x-canonical-private-synchronous:osd \
        -i "$icon_name" \
        "$brightness%" \
        "$bar"
}

BUSES=($(get_buses))

if [ ${#BUSES[@]} -eq 0 ]; then
    echo "No monitors detected via ddcutil"
    exit 1
fi

case "$1" in
    up)
        # Get current brightness from first monitor
        current=$(get_brightness "${BUSES[0]}")
        new_brightness=$((current + 10))
        if [ $new_brightness -gt 100 ]; then
            new_brightness=100
        fi

        # Set all monitors to the same absolute value
        for bus in "${BUSES[@]}"; do
            ddcutil --bus "$bus" setvcp 10 $new_brightness &
        done
        wait
        send_notification "$new_brightness"
        ;;
    down)
        # Get current brightness from first monitor
        current=$(get_brightness "${BUSES[0]}")
        new_brightness=$((current - 10))
        if [ $new_brightness -lt 0 ]; then
            new_brightness=0
        fi

        # Set all monitors to the same absolute value
        for bus in "${BUSES[@]}"; do
            ddcutil --bus "$bus" setvcp 10 $new_brightness &
        done
        wait
        send_notification "$new_brightness"
        ;;
    set)
        if [ -z "$2" ]; then
            echo "Usage: $0 set <0-100>"
            exit 1
        fi
        for bus in "${BUSES[@]}"; do
            ddcutil --bus "$bus" setvcp 10 "$2" &
        done
        wait
        send_notification "$2"
        ;;
    get)
        for bus in "${BUSES[@]}"; do
            echo "Monitor on bus $bus:"
            ddcutil --bus "$bus" getvcp 10
            echo
        done
        ;;
    list)
        echo "Detected monitors:"
        ddcutil detect
        ;;
    *)
        echo "Usage: $0 {up|down|set <value>|get|list}"
        exit 1
        ;;
esac
