#!/usr/bin/env bash 
hyprlock
$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")/wall/wallpaper-restore.sh
hyprsessionmanager --restore-latest
