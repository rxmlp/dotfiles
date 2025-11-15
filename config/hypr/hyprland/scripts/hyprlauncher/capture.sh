#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR 


record_area="Record area"
record_monitor="Record monitor"

screenshot="Screenshot"
screenshot_all="All Screen"
screenshot_active="Active Screen"
screenshot_area="Area/Window"

copy='Copy'
save='Save'
copy_save='CopySave'
edit='Edit'
editor="pinta"

dmenu() {
    $HOME/.local/bin/hyprlauncher --dmenu
}

if pgrep -x wf-recorder >/dev/null; then
    record="Stop recording"
else
    record="Record"
fi

screenshot_record() {
    echo -e "$screenshot\n$record" | dmenu
}

dmenu_screenshot_option() {
    echo -e "$screenshot_all\n$screenshot_active\n$screenshot_area" | dmenu
}

screenshot_option() {
  selected_option_screenshot="$(dmenu_screenshot_option)"
  if [[ "$selected_option_screenshot" == "$screenshot_all" ]]; then
    screenshot_option_chosen=screen
    ${1}
  elif [[ "$selected_option_screenshot" == "$screenshot_active" ]]; then
    screenshot_option_chosen=output
    ${1}
  elif [[ "$selected_option_screenshot" == "$screenshot_area" ]]; then
    screenshot_option_chosen=area
    ${1}
  else exit 1
  fi
}

dmenu_screenshot_action() {
  echo -e "$copy\n$save\n$copy_save\n$edit" | dmenu
}

screenshot_action() {
  selected_chosen="$(dmenu_screenshot_action)"
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
  sleep 1
  GRIMBLAST_EDITOR="$editor" grimblast --notify "$screenshot_action_chosen" "$screenshot_option_chosen"
}

screenshot_init() {
    screenshot_option
    screenshot_action "takescreenshot"
}

record_area() {
  REGION=$(slurp)
  hyprctl notify 0 1500 "0" "Recoring started"
  wf-recorder -g "$REGION" -a --file=$HOME/Videos/recordings/area_$(date +"%Y-%m-%d_%H-%M-%S").mp4
}

record_monitor() {
  REGION=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
  hyprctl notify 0 1500 "0" "Recoring started"
  wf-recorder -o "$REGION" -a --file=$HOME/Videos/recordings/monitor_$(date +"%Y-%m-%d_%H-%M-%S").mp4
}

dmenu_record_options() {
  echo -e "$record_area\n$record_monitor" | dmenu
}

record_init() {
    if pgrep -x wf-recorder >/dev/null; then
        pkill wf-recorder
        hyprctl notify 5 2000 "0" "Recoring stopped"
    else
        record_option="$(dmenu_record_options)"
        if [[ "$record_option" == "$record_area" ]]; then
            record_area
        elif [[ "$record_option" == "$record_monitor" ]]; then
            record_monitor
        else exit 1
        fi
    fi
}

selected_init="$(screenshot_record)"
case ${selected_init} in
$screenshot)
  screenshot_init
  ;;
$record)
  record_init
  ;;
esac