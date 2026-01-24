#!/bin/bash

# Get the current power state using grep and awk
current_state=$(bluetoothctl show | grep -oP 'Powered:\s*\K\w+')

if [ "$current_state" = "yes" ]; then
    bluetoothctl power off
elif [ "$current_state" = "no" ]; then
    bluetoothctl power on
else
    # Use notify-send for unknown states
    notify-send -i info "Unknown Bluetooth state: $current_state"
fi
