#!/usr/bin/env sh

wallpapers="${HOME}/.config/hypr/wall"

# hyprctl hyprpaper reload "DP-1,$(fd . $wallpapers --type f -d 1 -e png -e jpg | shuf -n 1)"
sleep 2
while true; do
    pidof hyprpaper || (hyprpaper &)
    sleep 1
    hyprctl -q hyprpaper reload DP-1,$(fd . "$wallpapers" --type f -d 1 -e png -e jpg | shuf -n 1)
    hyprctl -q hyprpaper unload unused
    sleep 3600
done