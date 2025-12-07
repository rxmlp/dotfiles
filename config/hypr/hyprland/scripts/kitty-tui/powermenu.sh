#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR 

shutdown='  Shutdown'
reboot='󰑙  Reboot'
lock='  Lock'
suspend='󰒲  Suspend'
yes='  Yes'
no='󰜺  No'

#echo $(hyprctl -j activewindow | grep "tags":)

echo -ne '\033]2;powermenu\007'
focus_lock() {
  while true; do
    sleep 0.05
    hyprctl dispatch focuswindow title:powermenu >/dev/null || break
  done
}
focus_lock &

# Wrapper for fzf menus
fzf_menu() {
    fzf --prompt='> ' --ansi --height=100%
}

launcher() {
    echo -e "$shutdown\n$reboot\n$lock\n$suspend" | fzf_menu
}

confirm() {
    echo -e "$yes\n$no" | fzf_menu
}

option() {
    hyprctl dispatch tagwindow +powermenu
    confirmed="$(confirm)"
    if [[ "$confirmed" == "$yes" ]]; then
    hyprctl dispatch movetoworkspacesilent special:load
        case "$1" in
            --shutdown)
                systemctl poweroff
                ;;
            --reboot)
                systemctl reboot
                ;;
            --lock)
                playerctl pause -a &
                sleep 1; hyprlock
                ;;
            --suspend)
                playerctl pause -a &
                sleep 1; hyprlock &
                sleep 1; systemctl suspend
                ;;
            *)
                exit 0
                ;;
        esac
    fi
}

chosen="$(launcher)"
case "$chosen" in
    "$shutdown")
        option --shutdown
        ;;
    "$reboot")
        option --reboot
        ;;
    "$lock")
        option --lock
        ;;
    "$suspend")
        option --suspend
        ;;
esac
