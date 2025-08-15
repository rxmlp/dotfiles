#!/usr/bin/env bash

while ! pgrep -x "hyprpaper" > /dev/null; do
    echo "Waiting for hyprpaper to start..."
    sleep 1
done

wall_dir=$HOME/Pictures/Wallpapers
monitors=$(hyprctl monitors -j | jq -r '.[] | .name')
cache=$HOME/.cache/mpvpaper-hyprpaper
DP1_wall=$(sed -n 1p "$cache")
DP2_wall=$(sed -n 2p "$cache")

if [ ! -f "$cache" ]; then
    echo "Cache file $cache does not exist!"
    exit 1
fi

if echo "$monitors" | grep -q 'DP-1'; then
    if echo "$DP1_wall" | grep -qE '\.mp4$'; then
        mpvpaper DP-1 $wall_dir/DP-1/$DP1_wall -o "input-ipc-server=/tmp/mpv-socket-DP-1 --loop --mute" & disown
    else
        hyprctl hyprpaper reload DP-1,"$wall_dir/DP-1/$DP1_wall"
    fi
fi

if echo "$monitors" | grep -q 'DP-2'; then
        hyprctl hyprpaper reload DP-2,"$wall_dir/DP-2/$DP2_wall"
    else
        exit
fi