#!/usr/bin/env bash 
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR

env="$HOME/.config/hypr/hyprland/conf/env.conf"
status=$(grep '^\$border = ' "$env")


off() {
  sed -i "s|\$border = .*|\$border = 1|" $env
}

on() {
  sed -i "s|\$border = .*|\$border = |" $env
}

toggle () {
  if [[ "$status" == "\$border = 1" ]]; then
      on
  else
      off
  fi
}

case "$1" in
  toggle)
    toggle
    ;;
  off)
    off
    ;;
  on)
    on
    ;;
esac