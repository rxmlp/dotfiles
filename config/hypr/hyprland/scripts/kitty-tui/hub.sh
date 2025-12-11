#!/usr/bin/env bash
set -euo pipefail
echo -ne '\033]2;kitty-tui-hub\007'

HLS="$HOME/.config/hypr/hyprland/scripts"
hyprfixsh="$HLS/bin/hyprfix"

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

hide() {
  hyprctl dispatch movetoworkspacesilent special:load
}

options="$(
  cat <<EOF
$screenshot
$powermenu
$theme
$hyprfix
$bluetooth
$wifi
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
$hyprfix cursor
$hyprfix paper
$hyprfix idle
$hyprfix polkit
$hyprfix lock
EOF
)"

while true; do
  choice="$(printf '%s\n' "$options" | menu)" || exit 0

  case "$choice" in
    $screenshot) "$HLS/kitty-tui/capture.sh";;
    $powermenu) "$HLS/kitty-tui/powermenu.sh";;
    $wifi)     "$HLS/kitty-tui/wifi/wifimenu.sh";;
    $bluetooth) "$HLS/kitty-tui/bluetooth.sh";;
    $theme)
      theme_choice="$(printf '%s\n' "$theme_options" | menu)" || exit 0
      case "$theme_choice" in
        $wallpaper)   "$HLS/wall/mpvpaper-hyprpaper.sh" && exit 0;;
        $signal)    hide & "$HOME/.config/matugen/scripts/signal-matugen.sh" && exit 0;;
        $steam)    hide & "$HOME/.config/matugen/scripts/steam/steam-theme.sh" && exit 0;;
      esac
      ;;
    $hyprfix)
      hyprfix_choice="$(printf '%s\n' "$hyprfix_options" | menu)" || exit 0
      case "$hyprfix_choice" in
        "$hyprfix lock")   hide & "$hyprfixsh" lock && exit 0;;
        "$hyprfix paper")   hide & "$hyprfixsh" paper && exit 0;;
        "$hyprfix idle")    hide & "$hyprfixsh" idle && exit 0;;
        "$hyprfix polkit")    hide & "$hyprfixsh" polkit && exit 0;;
        "$hyprfix cursor")    hide & "$hyprfixsh" cursor && exit 0;;
      esac
      ;;
  esac
done
