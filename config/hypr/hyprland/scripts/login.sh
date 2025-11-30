#!/usr/bin/env bash 
hyprlock
$HOME/.config/hypr/hyprland/scripts/wall/wallpaper-restore.sh
$HOME/.config/hypr/hyprland/scripts/waybar.sh boot-off
hyprsessionmanager --restore-latest