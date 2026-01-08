#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR
echo -ne '\033]2;kitty-tui\007'

lockfile=/tmp/kitty-tui-hub.lock
if [ -f "$lockfile" ]; then
    echo "Script already running"
    exit 1
fi
touch "$lockfile"
trap "rm -f '$lockfile'; exit" INT TERM EXIT


hyprfixsh="$HLS/bin/hyprfix"

screenshot='󰍹  Screenshot / Record'
powermenu='󰐥  Powermenu'
hyprfix='  Hyprfix'
wifi='󰤨  Wi-Fi'
bluetooth='󰂯  Bluetooth'
update_mirrors='  Update Mirrors'

# Appearance
theme='󰸉  Appearance'
wallpaper='󰸉  Wallpaper'
signal='󰭹  Matugen Signal'
steam='  Matugen Steam'
border='󰢡  Border toggle'
opacity='󱡔  Opacity toggle'

# Wrapper for fzf menus
fzf_menu() {
    local header="$1"
    fzf --prompt='> ' --ansi --height=100% --header="$header"
}

hide() {
    hyprctl dispatch movetoworkspacesilent special:load
}

main_menu() {
    echo -e "$screenshot\n$powermenu\n$theme\n$hyprfix\n$update_mirrors\n$bluetooth\n$wifi" | fzf_menu "$(date '+%H:%M')"
}

theme_menu() {
    echo -e "$wallpaper\n$signal\n$steam\n$border\n$opacity" | fzf_menu "Appearance"
}

hyprfix_menu() {
    echo -e "$hyprfix cursor\n$hyprfix paper\n$hyprfix idle\n$hyprfix polkit\n$hyprfix lock" | fzf_menu "Hyprfix"
}

# Main loop
while true; do
    choice="$(main_menu)" || exit 0

    case "$choice" in
        "$screenshot")
            "$HLS/kitty-tui/capture.sh"
            ;;
        "$powermenu")
            "$HLS/kitty-tui/powermenu.sh"
            ;;
        "$wifi")
            "$HLS/kitty-tui/wifi/wifimenu.sh"
            ;;
        "$bluetooth")
            "$HLS/kitty-tui/bluetooth.sh"
            ;;
        "$update_mirrors")
            hide &
            "$HLS/bin/update-mirrors" pkexec && exit 0
            ;;
        "$theme")
            theme_choice="$(theme_menu)" || continue
            case "$theme_choice" in
                "$wallpaper")
                    "$HLS/wall/mpvpaper-hyprpaper.sh"
                    ;;
                "$signal")
                    hide &
                    "$HOME/.config/matugen/scripts/signal-matugen.sh" && exit 0
                    ;;
                "$steam")
                    hide &
                    "$HOME/.config/matugen/scripts/steam/steam-theme.sh" && exit 0
                    ;;
                "$border")
                    "$HLS/toggles/borders.sh" toggle
                    ;;
                "$opacity")
                    "$HLS/toggles/opacity.sh" toggle
                    ;;
            esac
            ;;
        "$hyprfix")
            hyprfix_choice="$(hyprfix_menu)" || continue
            case "$hyprfix_choice" in
                "$hyprfix lock")
                    hide &
                    "$hyprfixsh" lock && exit 0
                    ;;
                "$hyprfix paper")
                    hide &
                    "$hyprfixsh" paper && exit 0
                    ;;
                "$hyprfix idle")
                    hide &
                    "$hyprfixsh" idle && exit 0
                    ;;
                "$hyprfix polkit")
                    hide &
                    "$hyprfixsh" polkit && exit 0
                    ;;
                "$hyprfix cursor")
                    hide &
                    "$hyprfixsh" cursor && exit 0
                    ;;
            esac
            ;;
    esac
done
