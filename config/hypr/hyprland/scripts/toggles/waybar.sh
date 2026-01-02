#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR

env="$HLC/env.conf"
wtop='grep -A1 "Layer level 2 (top):" <<< "$(hyprctl layers)" | grep waybar'


toggle() {
    pkill -SIGUSR1 waybar
    if eval "$wtop" > /dev/null 2>&1; then
        sed -i "s|\$wbar = .*|\$wbar = |" "$env"
    else
        sed -i "s|\$wbar = .*|\$wbar = 1|" "$env"
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
    waybar &
  fi
}

hidden() {
    start
    TIMEOUT=10
    waited=0
    while ! eval "$wtop" > /dev/null 2>&1; do
        sleep 0.1
        waited=$((waited + 1))
        if [ $waited -ge $((TIMEOUT * 10)) ]; then
            break
        fi
    done
    if eval "$wtop" > /dev/null 2>&1; then
        pkill -SIGUSR1 waybar
    fi
}

case "$1" in
  toggle)
    toggle
    ;;
  init)
    init
    ;;
  start)
    start
    ;;
  hidden)
    hidden
    ;;
esac
