#!/usr/bin/env sh

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

if pgrep -x wf-recorder >/dev/null; then
    printf '{"text":" Rec","class":"enabled"}'
    pkill wf-recorder
else
    printf '{"text":" Rec"}'
    wf-recorder -g "$(slurp)" -a --file=$HOME/Videos/recordings/${DATE}.mp4
fi
