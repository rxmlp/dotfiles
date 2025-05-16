#!/usr/bin/env bash
pidof swww-daemon || (swww-daemon & disown) 
monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
cd $HOME/.config/hypr/wall/$monitor
choices=$(fd . --type f -d 1 -e png -e jpg -e mp4 --format {/.} | shuf | fzf --cycle --preview='$HOME/.config/hypr/hyprland/scripts/wallpaper/fzf-preview.sh {}' --preview-window=right,70% --info=hidden --color prompt:green,pointer:green,current-bg:-1,current-fg:green,gutter:-1,border:bright-black,current-hl:red,hl:red)
choice=$(fd $choices)
old_mpv=$(pgrep -f "mpvpaper $monitor")

save_to_cache() {
  local monitor="$1"
  local choice="$2"
  local cache_file="$HOME/.config/hypr/wall/cache"

  # Read the current content of the cache file into an array
  mapfile -t lines < "$cache_file"

  # Determine the line to modify
  case "$monitor" in
    "DP-1")
      lines[0]="${choice}"
      ;;
    "DP-2")
      lines[1]="${choice}"
      ;;
    *)
      echo "Unknown monitor: $monitor"
      return 1
      ;;
  esac

  # Write the updated content back to the cache file
  printf "%s\n" "${lines[@]}" > "$cache_file"
}


if [ -n "$choice" ] && [ -f "$choice" ]; then
  if [[ "$choice" =~ \.(mp4)$ ]]; then
    hyprctl dispatch movetoworkspacesilent special:load
    matugen -c ~/.config/matugen/matugen.toml image $(fd "$choices"-mpv.png .thumbnails)
    if [[ "$monitor" =~ DP-1 ]]; then
      matugen -c ~/.config/matugen/matugen.toml image $(fd "$choices"-mpv.png .thumbnails)
    fi
    kill $old_mpv
    save_to_cache "$monitor" "$choice"
    # mpvpaper $monitor $choice -o "input-ipc-server=/tmp/mpv-socket-$monitor --loop --mute"
  fi
  if [[ "$choice" =~ \.(png|jpg)$ ]]; then
    save_to_cache "$monitor" "$choice"
    swww img -o $monitor "$choice"
    if [[ "$monitor" =~ DP-1 ]]; then
      matugen -c ~/.config/matugen/matugen.toml image "$choice"
    fi
    # matugen -c ~/.config/matugen/matugen.toml image "$choice"
    kill $old_mpv
  fi
fi


