#!/usr/bin/env bash
set -euo pipefail
echo -ne '\033]2;kitty-tui-hub\007'

HLS="$HOME/.config/hypr/hyprland/scripts"

clock_header() {
  date '+%H:%M'
}

menu() {
  fzf --ansi \
      --prompt='> ' \
      --height=100% \
      --header="$(clock_header)"
}

options="$(
  cat <<EOF
󰍹  Screenshot / Record
󰐥  Powermenu
󰸉  Wallpaper
󰤨  Wi-Fi
󰂯  Bluetooth
EOF
)"

while true; do
  choice="$(printf '%s\n' "$options" | menu)" || exit 0

  case "$choice" in
    *Screenshot*) "$HLS/kitty-tui/capture.sh" ;;
    *Powermenu*) "$HLS/kitty-tui/powermenu.sh" ;;
    *Wallpaper*) "$HLS/wall/mpvpaper-hyprpaper.sh" ;;
    *Wi-Fi*)     "$HLS/kitty-tui/wifi/wifimenu.sh" ;;
    *Bluetooth*) "$HLS/kitty-tui/bluetooth.sh" ;;
  esac
done
