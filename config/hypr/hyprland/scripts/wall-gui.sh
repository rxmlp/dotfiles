#!/usr/bin/env sh
pidof hyprpaper || (hyprpaper & disown) 
monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
cd $HOME/.config/hypr/wall
choices=$(fd . --type f -d 1 --format {/.} | shuf | fzf --cycle --preview='$HOME/.config/hypr/hyprland/scripts/fzf-preview.sh {}' --preview-window=right,70% --info=hidden --color prompt:green,pointer:green,current-bg:-1,current-fg:green,gutter:-1,border:bright-black,current-hl:red,hl:red)
choice_fd=$(fd $choices)
choice="$HOME/.config/hypr/wall/$choice_fd"
old_mpv=$(pgrep -f "mpv --wayland-app-id=mpv-bg")


choice_fd_thumbnails=$(fd "$choices"-mpv.png .thumbnails)
choice_thumbnails="$HOME/.config/hypr/wall/$choice_fd_thumbnails"

if [ -n "$choice" ] && [ -f "$choice" ]; then
  if [[ "$choice" =~ \.(mp4)$ ]]; then
    hyprctl dispatch movetoworkspacesilent special:load
    matugen -c ~/.config/matugen/matugen.toml image $choice_thumbnails
    kill $old_mpv
    mpv --wayland-app-id="mpv-bg" --loop --mute --load-scripts=no "$choice" --input-ipc-server=/tmp/mpv-socket-$monitor
  fi
  if [[ "$choice" =~ \.(png|jpg)$ ]]; then
    hyprctl -q hyprpaper reload "$monitor,$choice"
    hyprctl -q hyprpaper unload unused
    matugen -c ~/.config/matugen/matugen.toml image $choice
    kill $old_mpv
    pkill -f hyprpaper-random.sh
  fi
fi