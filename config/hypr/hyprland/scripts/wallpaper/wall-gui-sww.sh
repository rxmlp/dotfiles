#!/usr/bin/env bash
pidof swww-daemon || (swww-daemon & disown) 
monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
cd $HOME/.config/hypr/wall/$monitor
choices=$(fd . --type f -d 1 --format {/.} | shuf | fzf --cycle --preview='$HOME/.config/hypr/hyprland/scripts/wallpaper/fzf-preview.sh {}' --preview-window=right,70% --info=hidden --color prompt:green,pointer:green,current-bg:-1,current-fg:green,gutter:-1,border:bright-black,current-hl:red,hl:red)
choice=$(fd $choices)
old_mpv=$(pgrep -f "mpv --wayland-app-id=mpv-bg")

if [ -n "$choice" ] && [ -f "$choice" ]; then
  if [[ "$choice" =~ \.(mp4)$ ]]; then
    hyprctl dispatch movetoworkspacesilent special:load
    matugen -c ~/.config/matugen/matugen.toml image $(fd "$choices"-mpv.png .thumbnails)
    kill $old_mpv
    mpv --wayland-app-id="mpv-bg" --loop --mute --load-scripts=no "$choice" --input-ipc-server=/tmp/mpv-socket-$monitor
  fi
  if [[ "$choice" =~ \.(png|jpg)$ ]]; then
    swww img -o $monitor "$choice"
    matugen -c ~/.config/matugen/matugen.toml image "$choice"
    kill $old_mpv
  fi
fi