#!/usr/bin/env bash 
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR

# Get the DP/HDMI port of whatever is set as $monitor_primary in /hypr/hyprland/conf/devices.conf
source $HOME/.config/hypr/hyprland/scripts/monitor-env.sh
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

# Start waybar (Real shocker)
waybar
