#!/usr/bin/env bash

theme='power-menu'
uptime="$(uptime -p | sed -e 's/up //g')"
host=$(cat /etc/hostname)

# Options
shutdown=' Shutdown'
reboot=' Reboot'
lock=' Lock'
suspend=' Suspend'
logout=' Logout'
yes='Yes'
no='No'

# Rofi CMD
rofi_cmd() {
  rofi -dmenu \
    -p "$host" \
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
  echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

rofi_canceled() {
  rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 500px;}' \
    -theme-str 'mainbox {children: [ "message", "listview" ];}' \
    -theme-str 'listview {columns: 1; lines: 1;}' \
    -theme-str 'element-text {horizontal-align: 0.5;}' \
    -theme-str 'textbox {horizontal-align: 0.5;}' \
    -dmenu \
    -p 'Cancelled' \
    -mesg 'One or more applications are running, shutting down cancelled.' \
    -theme "$dir/$theme".rasi
  exit 1
}

rofi_killing_steam() {
  rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 500px;}' \
    -theme-str 'mainbox {children: [ "message", "listview" ];}' \
    -theme-str 'listview {columns: 1; lines: 1;}' \
    -theme-str 'element-text {horizontal-align: 0.5;}' \
    -theme-str 'textbox {horizontal-align: 0.5;}' \
    -dmenu \
    -p 'Cancelled' \
    -mesg 'Steam was running, try again in a few seconds. (Steam is being killed)' \
    -theme "$dir/$theme".rasi
  exit 1
}

ctloff() {
  if pgrep -f "ollama" > /dev/null || pgrep -f "timeshift" > /dev/null; then
    echo -e "Ohh ok" | rofi_canceled; else
      if pgrep -f "steam" > /dev/null; then
        pkill steam
        echo -e "Ohh ok" | rofi_killing_steam; else
        systemctl poweroff
      fi
  fi
}

ctlreboot() {
  if pgrep -f "ollama" > /dev/null || pgrep -f "timeshift" > /dev/null; then
    echo -e "Ohh ok" | rofi_canceled; else
      if pgrep -f "steam" > /dev/null; then
        pkill steam
        echo -e "Ohh ok" | rofi_killing_steam; else
        systemctl reboot
      fi
  fi
}

# Execute Command
run_cmd() {
  selected="$(confirm_exit)"
  if [[ "$selected" == "$yes" ]]; then
    if [[ $1 == '--shutdown' ]]; then
      ctloff
    elif [[ $1 == '--reboot' ]]; then
      ctlreboot
    elif [[ $1 == '--lock' ]]; then
      playerctl pause -a
      hyprlock
    elif [[ $1 == '--suspend' ]]; then
      playerctl pause -a
      hyprlock
      sleep 1; systemctl suspend
    elif [[ $1 == '--logout' ]]; then
      if [[ "$DESKTOP_SESSION" == 'hyprland' ]]; then
        hyprctl dispatch exit 1
      fi
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
  $logout)
    run_cmd --logout
    ;;
esac
