#!/usr/bin/env bash
set -euo pipefail
echo -ne '\033]2;kitty-tui-hub\007'

lockfile=/tmp/kitty-tui.lock
if [ -f "$lockfile" ]; then
    echo "Script already running"
    exit 1
fi
touch "$lockfile"
trap "rm -f '$lockfile'; exit" INT TERM EXIT

hyprfixsh="$HLS/bin/hyprfix"

screenshot="󰍹  Screenshot / Record"
powermenu="󰐥  Powermenu"
hyprfix="  Hyprfix"
wifi="󰤨  Wi-Fi"
bluetooth="󰂯  Bluetooth"
update_mirrors="  Update Mirrors"

# Appearance
theme="󰸉  Appearance"
wallpaper="󰸉  Wallpaper"
signal="󰭹  Matugen Signal"
steam="  Matugen Steam"
border="󰢡  Border toggle"
opacity="󱡔  Opacity toggle"
waybar="󱔓  Waybar toggle"


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

# Main
options="$(
  cat <<EOF
$screenshot
$powermenu
$theme
$hyprfix
$update_mirrors
$bluetooth
$wifi
EOF
)"
# X #

# Appearance
theme_options="$(
  cat <<EOF
$wallpaper
$signal
$steam
$border
$opacity
$waybar
EOF
)"
# X #

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
    $update_mirrors)    hide & "$HLS/bin/update-mirrors" pkexec && exit 0;;
    $theme)
      theme_choice="$(printf '%s\n' "$theme_options" | menu)" || exit 0
      case "$theme_choice" in
        $wallpaper)   "$HLS/wall/mpvpaper-hyprpaper.sh" && exit 0;;
        $signal)    hide & "$HOME/.config/matugen/scripts/signal-matugen.sh" && exit 0;;
        $steam)    hide & "$HOME/.config/matugen/scripts/steam/steam-theme.sh" && exit 0;;
        $border)   "$HLS/toggles/borders.sh" toggle && exit 0;;
        $opacity)   "$HLS/toggles/opacity.sh" toggle && exit 0;;
        $waybar)   "$HLS/toggles/waybar.sh" toggle && exit 0;;
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
