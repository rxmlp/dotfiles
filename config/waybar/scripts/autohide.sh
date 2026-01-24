#!/bin/bash

waybar -c ~/.config/waybar/scripts/autohide-conf.jsonc &


monitor_primary=$(hyprctl monitors -j | jq -r --arg desc "$(grep '^\$monitor_primary = desc:' "$HL/conf/devices.conf" | sed -E 's/^\$monitor_primary = desc:(.*)$/\1/')" '.[] | select(.description == $desc) | .name')
SHOW_THRESHOLD=10
HIDE_THRESHOLD=22
visible=true

while pgrep -x waybar > /dev/null; do
    cursorpos=$(hyprctl cursorpos -j)

    y=$(echo "$cursorpos" | jq -r '.y')
    monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

    if [ "$monitor" = "$monitor_primary" ]; then
        if [ "$y" -lt "$SHOW_THRESHOLD" ]; then
            if [ "$visible" = "false" ]; then
                killall -SIGUSR1 waybar
                visible=true
            fi
        elif [ "$y" -gt "$HIDE_THRESHOLD" ]; then
            if [ "$visible" = "true" ]; then
                killall -SIGUSR2 waybar
                visible=false
            fi
        fi
    fi

    sleep 0.1
done
