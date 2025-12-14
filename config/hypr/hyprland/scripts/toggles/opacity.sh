#!/usr/bin/env bash 
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR

status=$(grep '^\$opacity = ' "$HLC")


off() {
  sed -i "s|\$opacity = .*|\$opacity = 1|" $HLC
}

on() {
  sed -i "s|\$opacity = .*|\$opacity = |" $HLC
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