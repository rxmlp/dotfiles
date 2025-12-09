#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: \"$BASH_COMMAND\" failed" >&2; exit 1' ERR

echo -ne '\033]2;kitty-tui-bluetooth\007'

tag_start_scan="󰂰  Start scan"
tag_stop_scan="󰙧  Stop scan"
tag_refresh="  Refresh"

tag_bluetooth_on="󰂲  Disable Bluetooth"
tag_bluetooth_off="󰂯  Enable Bluetooth"

tag_discoverable_on="  Discoverable:  "
tag_discoverable_off="  Discoverable:  "

tag_pairable_on="  Pairable:      "
tag_pairable_off="󱖡  Pairable:      "

tag_back="  Back"
tag_connected_yes="󰂱  Connected:   "
tag_connected_no="󰂲  Connected:   "
tag_paired_yes="  Paired:      "
tag_paired_no="󱖡  Paired:      "
tag_trusted_yes="󰳈  Trusted:    "
tag_trusted_no="  Trusted:    "

menu() {
  local prompt="$1"
  fzf --ansi --prompt="$prompt > " --height=100%
}

menu_small() {
  local prompt="$1"
  fzf --ansi --prompt="$prompt > " --height=40%
}

enable_bt() {
  if rfkill list bluetooth 2>/dev/null | grep -q 'blocked: yes'; then
    rfkill unblock bluetooth && sleep 2
  fi
  if ! bluetoothctl power on >/dev/null 2>&1; then
    notify-send "Failed to turn on Bluetooth!"
  fi
}

disable_bt() {
  if ! bluetoothctl power off >/dev/null 2>&1; then
    notify-send "Failed to turn off Bluetooth!"
  fi
}

discoverable_on()  { bluetoothctl discoverable on  >/dev/null 2>&1; }
discoverable_off() { bluetoothctl discoverable off >/dev/null 2>&1; }
pairable_on()      { bluetoothctl pairable on      >/dev/null 2>&1; }
pairable_off()     { bluetoothctl pairable off     >/dev/null 2>&1; }

start_scan() {
  tmux new-session -d -s bluetooth_session "bluetoothctl"
  tmux send-keys -t bluetooth_session "scan on" C-m
}

stop_scan() {
  if bluetoothctl show | grep -q "Discovering: yes"; then
    tmux send-keys -t bluetooth_session "scan off" C-m || true
    tmux kill-session -t bluetooth_session 2>/dev/null || true
  fi
}

connect_dev() {
  if bluetoothctl connect "$mac" >/dev/null 2>&1; then
    notify-send "Connected to: $name"
  else
    notify-send "Failed to connect to: $name!"
  fi
}

disconnect_dev() {
  bluetoothctl disconnect "$mac" >/dev/null 2>&1 || true
}

pair_dev() {
  if bluetoothctl pair "$mac" >/dev/null 2>&1; then
    notify-send "Paired with: $name"
  else
    notify-send "Failed to pair: $name!"
  fi
}

unpair_dev() {
  bluetoothctl remove "$mac" >/dev/null 2>&1 || true
}

trust_dev() {
  bluetoothctl trust "$mac" >/dev/null 2>&1 || true
}

untrust_dev() {
  bluetoothctl untrust "$mac" >/dev/null 2>&1 || true
}

get_device_info() {
  mac=$(bluetoothctl devices | grep -F " $1" | awk '{print $2}' | head -1)
  device_info=$(printf '%s\n' "$mac" | xargs bluetoothctl info 2>/dev/null || true)
  name="$1"

  if grep -q "Connected: yes" <<<"$device_info"; then
    connected="$tag_connected_yes"
  else
    connected="$tag_connected_no"
  fi

  if grep -q "Paired: yes" <<<"$device_info"; then
    paired="$tag_paired_yes"
  else
    paired="$tag_paired_no"
  fi

  if grep -q "Trusted: yes" <<<"$device_info"; then
    trusted="$tag_trusted_yes"
  else
    trusted="$tag_trusted_no"
  fi
}

show_device_submenu() {
  local dev_name="$1"
  get_device_info "$dev_name"

  while true; do
    local opts choice
    opts=$(printf '%s\n%s\n%s\n%s\n' "$tag_back" "$connected" "$paired" "$trusted")
    choice=$(printf '%s\n' "$opts" | menu_small "Bluetooth: $dev_name") || { stop_scan; exit 0; }

    case "$choice" in
      "$tag_back") return ;;
      "$tag_connected_no") connect_dev ;;
      "$tag_connected_yes") disconnect_dev ;;
      "$tag_paired_no") pair_dev ;;
      "$tag_paired_yes") unpair_dev ;;
      "$tag_trusted_no") trust_dev ;;
      "$tag_trusted_yes") untrust_dev ;;
    esac
  done
}

menu_setup() {
  bluetooth_status=$(bluetoothctl show 2>/dev/null || true)

  if grep -q "Powered: yes" <<<"$bluetooth_status"; then
    power="$tag_bluetooth_on"
    devices=$(bluetoothctl devices | awk '{$1="";$2=""; sub(/^  /,""); print}' | tac)

    if grep -q "Discovering: yes" <<<"$bluetooth_status"; then
      scan="$tag_stop_scan"
    else
      scan="$tag_start_scan"
    fi

    if grep -q "Discoverable: yes" <<<"$bluetooth_status"; then
      discoverable="$tag_discoverable_on"
    else
      discoverable="$tag_discoverable_off"
    fi

    if grep -q "Pairable: yes" <<<"$bluetooth_status"; then
      pairable="$tag_pairable_on"
    else
      pairable="$tag_pairable_off"
    fi

    refresh="$tag_refresh"
  else
    scan=""
    discoverable=""
    pairable=""
    refresh=""
    power="$tag_bluetooth_off"
    devices=""
  fi

  mainmenu_options=$(printf '%s\n%s\n%s\n%s\n%s\n%s\n' \
    "$power" "$discoverable" "$pairable" "$scan" "$refresh" "$devices" | sed '/^$/d')
}

show_mainmenu() {
  while true; do
    menu_setup
    choice=$(printf '%s\n' "$mainmenu_options" | menu "Bluetooth") || { stop_scan; exit 0; }

    case "$choice" in
      "$tag_bluetooth_on")  disable_bt ;;
      "$tag_bluetooth_off") enable_bt ;;
      "$tag_discoverable_on")  discoverable_off ;;
      "$tag_discoverable_off") discoverable_on ;;
      "$tag_pairable_on")      pairable_off ;;
      "$tag_pairable_off")     pairable_on ;;
      "$tag_start_scan")       start_scan ;;
      "$tag_stop_scan")        stop_scan ;;
      "$tag_refresh")          : ;;
      *)
        # device name line
        dev_name="$choice"
        show_device_submenu "$dev_name"
        ;;
    esac
  done
}

show_mainmenu
stop_scan
