#!/usr/bin/env bash 
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR

env="$HOME/.config/hypr/hyprland/conf/env.conf"
status=$(grep '^\$less_anim = ' "$env")


off() {
  sed -i "s|\$less_anim = .*|\$less_anim = 1|" $env
}

on() {
  sed -i "s|\$less_anim = .*|\$less_anim = |" $env
}

toggle () {
  if [[ "$status" == "\$less_anim = 1" ]]; then
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