#!/usr/bin/env bash 
hyprlock
$HOME/.config/hypr/hyprland/scripts/wall/wallpaper-restore.sh
hyprctl dispatch workspace 10
hyprctl dispatch workspace 1
$HOME/.config/hypr/hyprland/scripts/session-management/hyprland-restore-session