#!/usr/bin/env bash
set -euo pipefail
echo -ne '\033]2;kitty-tui-hub\007'

HLS="$HOME/.config/hypr/hyprland/scripts"
hyprfixsh="$HOME/.local/bin-scripts/hyprfix"

screenshot="󰍹  Screenshot / Record"
powermenu="󰐥  Powermenu"
theme="󰸉  Theme"
wallpaper="󰸉  Wallpaper"
signal="󰭹  Matugen Signal"
steam="  Matugen Steam"
wifi="󰤨  Wi-Fi"
bluetooth="󰂯  Bluetooth"
hyprfix="  Hyprfix"


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
$screenshot
$powermenu
$theme
$hyprfix
$wifi
$bluetooth
EOF
)"

theme_options="$(
  cat <<EOF
$wallpaper
$signal
$steam
EOF
)"

hyprfix_options="$(
  cat <<EOF
$hyprfix paper
$hyprfix idle
$hyprfix polkit
$hyprfix cursor
EOF
)"

while true; do
  choice="$(printf '%s\n' "$options" | menu)" || exit 0

  case "$choice" in
    *$screenshot*) "$HLS/kitty-tui/capture.sh" && exit 0;;
    *$powermenu*) "$HLS/kitty-tui/powermenu.sh" && exit 0;;
    *$wifi*)     "$HLS/kitty-tui/wifi/wifimenu.sh" && exit 0;;
    *$bluetooth*) "$HLS/kitty-tui/bluetooth.sh" && exit 0;;
    *$theme*)
      theme_choice="$(printf '%s\n' "$theme_options" | menu)" || continue
      case "$theme_choice" in
        *$wallpaper*)   "$HLS/wall/mpvpaper-hyprpaper.sh" && exit 0;;
        *$signal*)    hyprctl dispatch movetoworkspacesilent special:load & "$HOME/.config/matugen/scripts/signal-matugen.sh" && exit 0;;
        *$steam*)    hyprctl dispatch movetoworkspacesilent special:load & "$HOME/.config/matugen/scripts/steam/steam-theme.sh" && exit 0;;
      esac
      ;;
    *$hyprfix*)
      hyprfix_choice="$(printf '%s\n' "$hyprfix_options" | menu)" || continue
      case "$hyprfix_choice" in
        *$hyprfix*|*paper*)   "$hyprfixsh" paper && exit 0;;
        *$hyprfix*|*idle*)    "$hyprfixsh" idle && exit 0;;
        *$hyprfix*|*polkit*)    "$hyprfixsh" polkit && exit 0;;
        *$hyprfix*|*cursor*)    "$hyprfixsh" cursor && exit 0;;
      esac
      ;;
  esac
done
