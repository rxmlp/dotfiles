#!/usr/bin/env sh

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

if pgrep -x wf-recorder >/dev/null; then
    pkill wf-recorder
    hyprctl notify 5 2000 "0" "Recoring stopped"
else
  REGION=$(slurp)
  hyprctl notify 0 1500 "0" "Recoring started"
  wf-recorder -g "$REGION" -a --file=$HOME/Videos/recordings/${DATE}.mp4
fi
