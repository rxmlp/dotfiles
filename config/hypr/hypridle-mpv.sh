#!/usr/bin/env bash

pause() {
if pgrep -f mpv > /dev/null; then 
    echo '{ "command": ["set_property", "pause", true] }' | socat - /tmp/mpv-socket-$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name') > /dev/null 2>&1 
fi
}

resume() {
if pgrep -f mpv > /dev/null; then 
    echo '{ "command": ["set_property", "pause", false] }' | socat - /tmp/mpv-socket-$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name') > /dev/null 2>&1 
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