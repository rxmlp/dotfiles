#!/usr/bin/env bash 
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR



toggle() {
  if ! pgrep -x "waybar" > /dev/null; then
      sed -i "s|\$less_anim = .*|\$less_anim = |" ~/.config/hypr/hyprland/conf/env.conf
      waybar
  else
      sed -i "s|\$less_anim = .*|\$less_anim = 1|" ~/.config/hypr/hyprland/conf/env.conf
      pkill waybar
  fi
}

restart() {
  if pgrep -x "waybar" > /dev/null; then
      pkill -SIGUSR2 waybar
  fi
}

boot() {
  # Get the DP/HDMI port of whatever is set as $monitor_primary in /hypr/hyprland/conf/devices.conf
  source $HOME/.config/hypr/hyprland/scripts/env.sh
  # Exit if there is no $monitor_primary
  if [[ -z "$monitor_primary_port" ]]; then
    echo "Error: monitor_primary_port is not set. Exiting."
    exit 1
  fi

  WBconf="$HOME/.config/waybar/config"

  # Extract the current output value from the config
  current_output=$(grep -Po '"output": *"\K[^"]+' "$WBconf")

  # Set the port grabbed as the output in waybar if not already correct
  if [[ "$current_output" == "$monitor_primary_port" ]]; then
    echo "Output is already set to '$monitor_primary_port'. No update needed."
  else
    sed -i "s/\"output\": *\"[^\"]*\"/\"output\": \"$monitor_primary_port\"/" "$WBconf"
    echo "Updated output from '$current_output' to '$monitor_primary_port'."
  fi
}

boot-off() {
  sed -i "s|\$less_anim = .*|\$less_anim = 1|" ~/.config/hypr/hyprland/conf/env.conf
  boot
}

boot-on() {
  sed -i "s|\$less_anim = .*|\$less_anim = |" ~/.config/hypr/hyprland/conf/env.conf
  boot
  waybar
}



case "$1" in
  toggle)
    toggle
    ;;
  boot-off)
    boot-off
    ;;
  boot-on)
    boot-on
    ;;
esac