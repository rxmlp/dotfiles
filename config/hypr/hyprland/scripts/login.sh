#!/usr/bin/env bash 
hyprlock
$HOME/.config/hypr/hyprland/scripts/wall/wallpaper-restore.sh
hyprctl dispatch workspace 10
hyprctl dispatch workspace 1
$HOME/.local/bin/hyprsessionmanager --ask-restore-latest