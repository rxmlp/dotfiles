#!/usr/bin/env bash

# Configuration
DEFAULT_TEMP=6000  # Default temperature (daylight)
SUNSET_TIME="20:00"  # Sunset time
SUNRISE_TIME="07:00" # Sunrise time
NIGHT_TEMP=3300      # Temperature at midnight
GRADUAL_INTERVAL=10  # Interval for gradual changes (in minutes)

# Function to convert time to minutes since midnight
time_to_minutes() {
    IFS=: read -r hour minute <<<"$1"
    echo $((hour * 60 + minute))
}

# Function to calculate temperature based on time
calculate_temp() {
    local current_minutes=$(time_to_minutes "$1")
    local sunset_minutes=$(time_to_minutes "$SUNSET_TIME")
    local sunrise_minutes=$(time_to_minutes "$SUNRISE_TIME")
    local night_minutes=$((1440 - sunset_minutes + sunrise_minutes)) # Total night duration in minutes

    if ((current_minutes >= sunrise_minutes && current_minutes < sunset_minutes)); then
        echo $DEFAULT_TEMP
    else
        if ((current_minutes < sunrise_minutes)); then
            current_minutes=$((current_minutes + 1440))
        fi
        elapsed_night_minutes=$((current_minutes - sunset_minutes))
        progress=$((elapsed_night_minutes * 100 / night_minutes))
        temp=$((DEFAULT_TEMP - (DEFAULT_TEMP - NIGHT_TEMP) * progress / 100))
        echo $temp
    fi
}

# Main loop
while true; do
    current_time=$(date +"%H:%M")
    temperature=$(calculate_temp "$current_time")
    echo "Setting temperature to ${temperature}K at $current_time"
    hyprctl notify 1 2000 "0" "Nightmode ${temperature}K"
    hyprsunset -t "$temperature"
    sleep $((GRADUAL_INTERVAL * 60)) # Sleep for the gradual interval
done