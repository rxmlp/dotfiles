#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR
echo -ne '\033]2;kitty-tui\007'

screenshot_all="󰍹 󰨇  All Screen"
screenshot_active="󰨇  Active Screen"
screenshot_area="󰕢  Area/Window"
copy='  Copy'
save='  Save'
copy_save='  CopySave'
edit='  Edit'
editor="pinta"

menu() {
    fzf --prompt='> ' --ansi --height=100%
}

menu_screenshot_option() {
    echo -e "$screenshot_all\n$screenshot_active\n$screenshot_area" | menu
}

screenshot_option() {
  selected_option_screenshot="$(menu_screenshot_option)"
  if [[ "$selected_option_screenshot" == "$screenshot_all" ]]; then
    screenshot_option_chosen=screen
  elif [[ "$selected_option_screenshot" == "$screenshot_active" ]]; then
    screenshot_option_chosen=output
  elif [[ "$selected_option_screenshot" == "$screenshot_area" ]]; then
    screenshot_option_chosen=area
  else exit 1
  fi
}

menu_screenshot_action() {
  echo -e "$copy\n$save\n$copy_save\n$edit" | menu
}

screenshot_action() {
  selected_chosen="$(menu_screenshot_action)"
  if [[ "$selected_chosen" == "$copy" ]]; then
    screenshot_action_chosen=copy
    ${1}
  elif [[ "$selected_chosen" == "$save" ]]; then
    screenshot_action_chosen=save
    ${1}
  elif [[ "$selected_chosen" == "$copy_save" ]]; then
    screenshot_action_chosen=copysave
    ${1}
  elif [[ "$selected_chosen" == "$edit" ]]; then
    screenshot_action_chosen=edit
    ${1}
  else exit 1
  fi
}

takescreenshot() {
  hyprctl dispatch movetoworkspacesilent special:load
  sleep 0.5
  GRIMBLAST_EDITOR="$editor" grimblast --notify "$screenshot_action_chosen" "$screenshot_option_chosen" 2>/dev/null
  exit 0
}

screenshot_option
screenshot_action "takescreenshot"
