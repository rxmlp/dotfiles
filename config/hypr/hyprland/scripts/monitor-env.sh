#!/usr/bin/env bash 

devices="$HOME/.config/hypr/hyprland/conf/devices.conf"

monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .description')
monitors=$(hyprctl monitors -j | jq -r '.[] | .description')
monitor_primary_desc=$(grep '^\$monitor_primary = desc:' "$devices" | sed -E 's/^\$monitor_primary = desc:(.*)$/\1/')
monitor_primary="$monitor_primary_desc"
monitor_primary_port=$(hyprctl monitors -j | jq -r --arg desc "$monitor_primary" '.[] | select(.description == $desc) | .name')
monitor_primary_path=monitor_primary
monitor_secondary_desc=$(grep '^\$monitor_secondary = desc:' "$devices" | sed -E 's/^\$monitor_secondary = desc:(.*)$/\1/')
monitor_secondary="$monitor_secondary_desc"
monitor_secondary_port=$(hyprctl monitors -j | jq -r --arg desc "$monitor_secondary" '.[] | select(.description == $desc) | .name')
monitor_secondary_path=monitor_secondary


cache=$HOME/.cache/mpvpaper-hyprpaper
wall_dir=$HOME/Pictures/Wallpapers


if [[ "$monitor" == "$monitor_primary" ]]; then
    monitor_path="$monitor_primary_path"
elif [[ "$monitor" == "$monitor_secondary" ]]; then
    monitor_path="$monitor_secondary_path"
else
    echo monitor_path="unknown"
    exit 1
fi

export monitor_path


hyprctl monitors -j | jq -r --arg desc "$(grep '^\$monitor_primary = desc:' "$devices" | sed -E 's/^\$monitor_primary = desc:(.*)$/\1/')" '.[] | select(.description == $desc) | .name'