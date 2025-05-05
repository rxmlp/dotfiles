#!/usr/bin/env bash

DATE=$(date +"%Y-%m-%d_%H-%M-%S")


area() {
if pgrep -x wf-recorder >/dev/null; then
    pkill wf-recorder
    hyprctl notify 5 2000 "0" "Recoring stopped"
else
  REGION=$(slurp)
  hyprctl notify 0 1500 "0" "Recoring started"
  wf-recorder -g "$REGION" -a --file=$HOME/Videos/recordings/${DATE}.mp4
fi
}

monitor() {
if pgrep -x wf-recorder >/dev/null; then
    pkill wf-recorder
    hyprctl notify 5 2000 "0" "Recoring stopped"
else
  REGION=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
  hyprctl notify 0 1500 "0" "Recoring started"
  wf-recorder -o "$REGION" -a --file=$HOME/Videos/recordings/${DATE}.mp4
fi
}

case "$1" in
  area)
    area
    ;;
  monitor)
    monitor
    ;;
  *)
    echo "Usage: $0 {area|monitor}"
    exit 1
    ;;
esac