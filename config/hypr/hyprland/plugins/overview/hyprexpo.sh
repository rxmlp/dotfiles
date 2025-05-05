#!/usr/bin/env bash

output=$(hyprctl cursorpos)

if [[ $output == -* ]]; then
    exit 1
else
    hyprctl dispatch hyprexpo:expo toggle
fi
exit