#!/usr/bin/env bash 
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR


off() {
  sed -i "s|\$wbar = .*|\$wbar = 1|" "$HLC"
  pkill waybar
}

on() {
  sed -i "s|\$wbar = .*|\$wbar = |" "$HLC"
  waybar > /dev/null & disown
}


toggle() {
  if ! pgrep -x "waybar" > /dev/null; then
    on
  else
    off
  fi
}

restart() {
  if pgrep -x "waybar" > /dev/null; then
      pkill -SIGUSR2 waybar
  fi
}

init() {
  source "$HLS/moni-env.sh" && get_monitor_primary
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

start() {
  init
  if pgrep -x "waybar" > /dev/null; then
    pkill -SIGUSR2 waybar
  else
    waybar
  fi
}

case "$1" in
  toggle)
    toggle
    ;;
  on)
    on
    ;;
  off)
    off
    ;;
  restart)
    restart
    ;;
  init)
    init
    ;;
  start)
    start
    ;;
esac