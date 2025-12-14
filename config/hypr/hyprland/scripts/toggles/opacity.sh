#!/usr/bin/env bash 
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR

env="$HLC/env.conf"
status=$(grep '^\$opacity = ' "$env")


off() {
  sed -i "s|\$opacity = .*|\$opacity = 1|" $env
}

on() {
  sed -i "s|\$opacity = .*|\$opacity = |" $env
}

toggle () {
  if [[ "$status" == "\$opacity = 1" ]]; then
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