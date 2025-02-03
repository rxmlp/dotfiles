#!/usr/bin/env sh

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
    if pgrep -f mpv > /dev/null; then
        echo '{ "command": ["set_property", "pause", true] }' | socat - /tmp/mpv-socket-$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name') > /dev/null 2>&1 
    fi
    hyprctl notify 2 2000 "0" "Game mode on"
    exit
fi



hyprctl reload
if pgrep -f mpv > /dev/null; then
    echo '{ "command": ["set_property", "pause", false] }' | socat - /tmp/mpv-socket-$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name') > /dev/null 2>&1 
fi
hyprctl notify 2 2000 "0" "Game mode off"