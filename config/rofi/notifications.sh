#!/bin/bash

# Fetch the notification history from Mako
notifications=$(makoctl history)

# Parse the notifications using jq
summaries=$(echo "$notifications" | jq -r '.data[][] | .app-name.data + " : " + .summary.data + " : " + .body.data')

# Use Rofi to select a notification
selected=$(echo "$summaries" | rofi -theme "power-menu".rasi -dmenu -p "Notification log")

