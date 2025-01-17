#!/usr/bin/env sh

# Define the directory containing wallpapers
wallpapers="${HOME}/.config/hypr/wall"

# Select a random wallpaper
wallpaper=$(find "$wallpapers" -type f | shuf -n 1)

# Preload the random wallpaper
hyprctl hyprpaper preload "$wallpaper"

# Apply the wallpaper
hyprctl hyprpaper wallpaper "DP-1,$wallpaper"