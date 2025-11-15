#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR 


shutdown='Shutdown'
reboot='Reboot'
lock='Lock'
suspend='Suspend'

launcher() {
  echo -e "$shutdown\n$reboot\n$lock\n$suspend" | hyprlauncher --dmenu
}

option() {
    if [[ $1 == '--shutdown' ]]; then
      systemctl poweroff
    elif [[ $1 == '--reboot' ]]; then
      systemctl reboot
    elif [[ $1 == '--lock' ]]; then
      playerctl pause -a &
      sleep 1; hyprlock
    elif [[ $1 == '--suspend' ]]; then
      playerctl pause -a &
      sleep 1; hyprlock &
      sleep 1; systemctl suspend
    else
        exit 0
    fi
}

chosen="$(launcher)"
case $chosen in
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
