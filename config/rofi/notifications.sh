#!/usr/bin/env bash

# Extract notification summaries
summaries=$(dunstctl history | jq -r '.data[][] | .appname.data + " : " + .body.data')

# Use Rofi to select a notification
selected=$(echo "$summaries" | rofi -dmenu -p "Notification log")
