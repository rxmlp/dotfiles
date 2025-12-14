#!/usr/bin/env bash 
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR

status=$(grep '^\$border = ' "$HLC")


off() {
  sed -i "s|\$border = .*|\$border = 1|" $HLC
}

on() {
  sed -i "s|\$border = .*|\$border = |" $HLC
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