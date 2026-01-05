#!/bin/bash
# Control brightness on both monitors

DP1="7"
DP2="8"

case "$1" in
    up)
        ddcutil --bus $DP1 setvcp 10 + 10
        ddcutil --bus $DP2 setvcp 10 + 10
        ;;
    down)
        ddcutil --bus $DP1 setvcp 10 - 10
        ddcutil --bus $DP2 setvcp 10 - 10
        ;;
    set)
        if [ -z "$2" ]; then
            echo "Usage: brightness-both.sh set <0-100>"
            exit 1
        fi
        ddcutil --bus $DP1 setvcp 10 $2
        ddcutil --bus $DP2 setvcp 10 $2
        ;;
    get)
        ddcutil --bus $DP1 getvcp 10
        ddcutil --bus $DP2 getvcp 10
        ;;
    *)
        echo "Usage: brightness-both.sh {up|down|set <value>|get}"
        exit 1
        ;;
esac
