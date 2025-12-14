#!/usr/bin/env bash 
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR

source "$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")/../env.sh" && get_monitors

cd "$wall_dir/$monitor_path"
choices=$(fd . --type f -d 1 -e png -e jpg -e mp4 --format {/.} | shuf | fzf --cycle --preview='$HOME/.config/hypr/hyprland/scripts/wall/fzf-preview.sh {}' --preview-window=right,70% --info=hidden --color prompt:green,pointer:green,current-bg:-1,current-fg:green,gutter:-1,border:bright-black,current-hl:red,hl:red)
choice=$(fd "$choices")
old_mpv=$(pgrep -f "mpvpaper "$monitor_primary_port"" || true)

save_to_cache() {
  local monitor="$1"
  local choice="$2"

  # Read the current content of the cache file into an array
  mapfile -t lines < "$cache"

  # Determine the line to modify
  case "$monitor" in
    "$monitor_primary")
      lines[0]="${choice}"
      ;;
    "$monitor_secondary")
      lines[1]="${choice}"
      ;;
    *)
      echo Unknown monitor: "$monitor"
      return 1
      ;;
  esac

  # Write the updated content back to the cache file
  printf "%s\n" "${lines[@]}" > "$cache"
}


if [ -n "$choice" ] && [ -f "$choice" ]; then
  if [[ "$choice" =~ \.(mp4)$ ]]; then
    hyprctl dispatch movetoworkspacesilent special:load
    if [[ "$monitor" =~ "$monitor_primary" ]]; then
      matugen -c ~/.config/matugen/matugen.toml image $(fd "$choices"-mpv.png .thumbnails)
    fi
    if [[ -n "$old_mpv" ]]; then
      kill "$old_mpv"
    fi
    save_to_cache "$monitor" "$choice"
    mpvpaper "$monitor_primary_port" "$choice" -o "input-ipc-server=/tmp/mpv-socket-$monitor_primary_port --loop --mute"
  fi
  if [[ "$choice" =~ \.(png|jpg)$ ]]; then
    save_to_cache "$monitor" "$choice"
    hyprctl hyprpaper reload desc:$monitor,"$HOME/Pictures/Wallpapers/$monitor_path/$choice"
    if [[ "$monitor" = "$monitor_primary" ]]; then
      matugen -c ~/.config/matugen/matugen.toml image "$choice"
      if [[ "$(printenv hyprlockwall)" = "on" ]]; then
        sed -i "s|\$hyprlockwall = .*|\$hyprlockwall = "\$HOME"/Pictures/Wallpapers/$monitor_path/$choice|" ~/.config/hypr/theme.conf
      fi
    if [[ -n "$old_mpv" ]]; then
      kill "$old_mpv"
    fi
    fi
  fi
fi