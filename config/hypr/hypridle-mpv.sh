#!/usr/bin/env bash
source $HOME/.config/hypr/hyprland/scripts/env.sh
pause() {
if pgrep -f mpvpaper > /dev/null; then 
    echo '{ "command": ["set_property", "pause", true] }' | socat - /tmp/mpv-socket-"$monitor_primary_port" > /dev/null 2>&1 
fi
}

resume() {
if pgrep -f mpvpaper > /dev/null; then 
    echo '{ "command": ["set_property", "pause", false] }' | socat - /tmp/mpv-socket-"$monitor_primary_port" > /dev/null 2>&1 
fi
}


case "$1" in
  pause)
    pause
    ;;
  resume)
    resume
    ;;
  *)
    exit 1
    ;;
esac