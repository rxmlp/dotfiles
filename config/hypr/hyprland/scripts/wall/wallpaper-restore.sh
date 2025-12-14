#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR

if ! pgrep -x "hyprpaper" > /dev/null; then
    hyprpaper &
    while ! pgrep -x "hyprpaper" > /dev/null; do
        echo "Waiting for hyprpaper to start..."
        sleep 1
    done
    echo "hyprpaper started."
else
    echo "hyprpaper is already running."
fi

source "$HLS/moni-env.sh" && get_monitors
monitor_primary_wall=$(sed -n 1p "$cache")
monitor_secondary_wall=$(sed -n 2p "$cache")

if [ ! -f "$cache" ]; then
    echo "Cache file "$cache" does not exist!"
    exit 1
fi

old_mpv=$(pgrep -f "mpvpaper "$monitor_primary_port"" || true)
if [[ -n "$old_mpv" ]]; then
    kill "$old_mpv"
fi

if echo "$monitors" | grep -q "$monitor_primary"; then
    if echo "$monitor_primary_wall" | grep -qE '\.mp4$'; then
        mpvpaper "$monitor_primary_port" "$wall_dir/$monitor_primary_path/$monitor_primary_wall" -o "input-ipc-server=/tmp/mpv-socket-"$monitor_primary_port" --loop --mute" & disown
    else
        hyprctl hyprpaper reload desc:$monitor_primary,"$wall_dir/$monitor_primary_path/$monitor_primary_wall"
    fi
fi

if echo "$monitors" | grep -q "$monitor_secondary"; then
        hyprctl hyprpaper reload desc:$monitor_secondary,"$wall_dir/$monitor_secondary_path/$monitor_secondary_wall"
    else
        exit
fi