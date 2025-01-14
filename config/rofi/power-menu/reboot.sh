#!/usr/bin/env sh

# Current Theme
dir="~/.config/waybar/scripts/power-menu/"
theme='style'

# Check if any of the applications are running
if pgrep -f "ollama" > /dev/null || pgrep -f "steam" > /dev/null || pgrep -f "timeshift" > /dev/null; then
  echo -e "Ohh ok" |
  rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 500px;}' \
    -theme-str 'mainbox {children: [ "message", "listview" ];}' \
    -theme-str 'listview {columns: 1; lines: 1;}' \
    -theme-str 'element-text {horizontal-align: 0.5;}' \
    -theme-str 'textbox {horizontal-align: 0.5;}' \
    -dmenu \
    -p 'Cancelled shutdown' \
    -mesg 'One or more applications are running, shutting down cancelled.' \
    -theme "$dir/$theme".rasi
  exit 1
fi

systemctl reboot