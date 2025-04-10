#!/usr/bin/env bash
swww-daemon & disown


cd $HOME/.config/hypr/wall
DP1_wall=$(sed -n 1p cache)
DP2_wall=$(sed -n 2p cache)


if hyprctl monitors -j | jq -r '.[] | .name' | grep -q 'DP-1'; then
    if echo "$DP1_wall" | grep -qE '\.mp4$'; then
        mpvpaper DP-1 DP-1/$DP1_wall -o "input-ipc-server=/tmp/mpv-socket-DP-1 --loop --mute"
    fi
fi

if hyprctl monitors -j | jq -r '.[] | .name' | grep -q 'DP-2'; then
    if echo "$DP2_wall" | grep -qE '\.mp4$'; then
        mpvpaper DP-2 DP-2/$DP2_wall -o "input-ipc-server=/tmp/mpv-socket-DP-2 --loop --mute"
    fi
fi