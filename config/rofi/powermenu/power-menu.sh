#!/usr/bin/env bash

theme='power-menu'
dir='~/.config/rofi/powermenu'
uptime="$(uptime -p | sed -e 's/up //g')"
time=$(date '+%A, %d %B %Y • %H:%M')

# Options
shutdown='      Shutdown'
reboot='      Reboot'
lock='      Lock'
suspend='      Suspend'
yes='Yes'
no='No'

# Rofi CMD
rofi_cmd() {
  rofi -dmenu \
    -p "$time" \
    -mesg "Uptime: $uptime" \
    -theme "$dir/$theme".rasi
}

# Confirmation CMD
confirm_cmd() {
  rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
    -theme-str 'mainbox {children: [ "message", "listview" ];}' \
    -theme-str 'listview {columns: 2; lines: 1;}' \
    -theme-str 'element-text {horizontal-align: 0.5;}' \
    -theme-str 'textbox {horizontal-align: 0.5;}' \
    -dmenu \
    -p 'Confirmation' \
    -mesg 'Are you Sure?' \
    -theme "$dir/$theme".rasi
}

# Ask for confirmation
confirm_exit() {
  echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$lock\n$suspend\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
  selected="$(confirm_exit)"
  if [[ "$selected" == "$yes" ]]; then
    if [[ $1 == '--shutdown' ]]; then
      systemctl poweroff
    elif [[ $1 == '--reboot' ]]; then
      systemctl reboot
    elif [[ $1 == '--lock' ]]; then
      playerctl pause -a
      hyprlock
    elif [[ $1 == '--suspend' ]]; then
      playerctl pause -a
      hyprlock &
      sleep 1; systemctl suspend
    fi
  else
    exit 0
  fi
}

# Actions
chosen="$(run_rofi)"
case $chosen in
  $shutdown)
    run_cmd --shutdown
    ;;
  $reboot)
    run_cmd --reboot
    ;;
  $lock)
      run_cmd --lock
    ;;
  $suspend)
    run_cmd --suspend
    ;;
esac
