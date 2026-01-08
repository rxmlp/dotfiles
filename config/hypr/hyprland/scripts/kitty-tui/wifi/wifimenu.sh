#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: \"$BASH_COMMAND\" failed" >&2; exit 1' ERR
echo -ne '\033]2;kitty-tui\007'

lockfile=/tmp/kitty-tui.lock
if [ -f "$lockfile" ]; then
    echo "Script already running"
    exit 1
fi
touch "$lockfile"
trap "rm -f '$lockfile'; exit" INT TERM EXIT

# Tags / labels
tag_wifi_disable="󰤭  Disable Wi-Fi"
tag_wifi_enable="󱚽  Enable Wi-Fi"
tag_manage_known="󱚾  Manage known networks"
tag_forget_connection="󰜺  Forget connection"
tag_autoconnect_on="  Autoconnect:  "
tag_autoconnect_off="  Autoconnect:  "
tag_back="  Back"
tag_rescan="  Re-scan"
tag_not_connected="󰤭  Not connected"

menu() {
  local prompt="$1"
  fzf --ansi --prompt="$prompt > " --height=100%
}

menu_small() {
  local prompt="$1"
  fzf --ansi --prompt="$prompt > " --height=40%
}

wifi_enabled() {
  nmcli -fields WIFI g | grep -qi enabled
}

get_current_ssid() {
  nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2}' | head -1
}

list_wifi() {
  # SSID, SIGNAL, SECURITY with icons
  nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list | awk -F: '
    NF>=2 {
      ssid=$1; sig=$2; sec=$3;
      if (ssid=="") ssid="[hidden]";
      icon="󰤯";
      if (sig>=80) icon="󰤨";
      else if (sig>=60) icon="󰤥";
      else if (sig>=40) icon="󰤢";
      printf "%s  %s  (%s)\n", icon, ssid, sec;
    }'
}

password_prompt() {
  # simple password prompt in terminal
  read -rsp "Wi-Fi password: " wifi_passwd
  echo
}

connect_wifi() {
  local line="$1"
  local ssid
  ssid=$(sed -E 's/^[^ ]+  ([^ ]+).*/\1/' <<< "$line")

  [[ -z "$ssid" || "$ssid" == "[hidden]" ]] && return 1

  local saved_connections
  saved_connections=$(nmcli -g NAME connection)
  if echo "$saved_connections" | grep -Fxq "$ssid"; then
    nmcli connection up id "$ssid" | grep -qi "successfully" && notify-send "Connected to: $ssid"
  else
    # require password if secure
    if grep -qE "\(WPA|WPA2|WPA3" <<< "$line"; then
      password_prompt
      [[ -z "${wifi_passwd:-}" ]] && return 1
      nmcli device wifi connect "$ssid" password "$wifi_passwd" | grep -qi "successfully" && notify-send "Connected to: $ssid"
    else
      nmcli device wifi connect "$ssid" | grep -qi "successfully" && notify-send "Connected to: $ssid"
    fi
  fi
}

manage_known_menu() {
  local known
  known=$(nmcli connection show | awk '/ wifi /{for(i=1;i<=NF;i++){if($i=="wifi"){print $1;break}}}')
  if [[ -z "$known" ]]; then
    echo "No known Wi-Fi networks." >&2
    sleep 1
    return
  fi

  local choice
  choice=$(printf '%s\n%s\n' "$tag_back" "$known" | menu_small "Known") || return

  [[ "$choice" == "$tag_back" ]] && return
  local net="$choice"

  while true; do
    # autoconnect state
    local ac
    ac=$(nmcli connection show "$net" | awk -F: '/autoconnect/{gsub(/^[ \t]+/, "", $2); print $2; exit}')
    local ac_tag="$tag_autoconnect_on"
    [[ "$ac" == "yes" ]] && ac_tag="$tag_autoconnect_off"

    local sub_choice
    sub_choice=$(printf '%s\n%s\n%s\n' "$tag_back" "$tag_forget_connection" "$ac_tag" | menu_small "$net") || return

    case "$sub_choice" in
      "$tag_back") return ;;
      "$tag_forget_connection")
        nmcli connection delete "$net"
        sleep 0.2
        return
        ;;
      "$tag_autoconnect_on")
        nmcli connection modify "$net" connection.autoconnect yes
        ;;
      "$tag_autoconnect_off")
        nmcli connection modify "$net" connection.autoconnect no
        ;;
    esac
  done
}

main_menu() {
  while true; do
    local prompt items cur ssid
    if wifi_enabled; then
      ssid=$(get_current_ssid)
      if [[ -z "$ssid" ]]; then
        cur="$tag_not_connected"
      else
        cur="󰤨  Connected: $ssid"
      fi
      prompt="$cur"
      items=$(printf '%s\n%s\n%s\n' "$tag_manage_known" "$tag_wifi_disable" "$tag_rescan")
      # append scan results
      items=$(printf '%s\n%s\n' "$items" "$(list_wifi)")
    else
      prompt="󰤭  Wi-Fi disabled"
      items="$tag_wifi_enable"
    fi

    local choice
    choice=$(printf '%s\n' "$items" | menu "$prompt") || exit 0

    case "$choice" in
      "$tag_wifi_enable")
        nmcli radio wifi on
        sleep 0.3
        ;;
      "$tag_wifi_disable")
        nmcli radio wifi off
        ;;
      "$tag_manage_known")
        manage_known_menu
        ;;
      "$tag_rescan")
        nmcli dev wifi rescan
        sleep 0.5
        ;;
      *)
        connect_wifi "$choice"
        ;;
    esac
  done
}

main_menu
