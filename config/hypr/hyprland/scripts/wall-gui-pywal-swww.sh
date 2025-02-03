#!/usr/bin/env sh

pidof swww-daemon || (swww-daemon & disown)
monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
cd $HOME/.config/hypr/wall
choices=$(fd . --type f -d 1 --format {/.} | shuf | fzf --cycle --preview='$HOME/.config/hypr/hyprland/scripts/fzf-preview.sh {}' --preview-window=right,70% --info=hidden --color prompt:green,pointer:green,current-bg:-1,current-fg:green,gutter:-1,border:bright-black,current-hl:red,hl:red)


choice_fd=$(fd $choices)
choice="$HOME/.config/hypr/wall/$choice_fd"

choice_fd_thumbnails=$(fd "$choices"-mpv.png .thumbnails)
choice_thumbnails="$HOME/.config/hypr/wall/$choice_fd_thumbnails"

if [ -n "$choice" ] && [ -f "$choice" ]; then
  if [[ "$choice" =~ \.(mp4)$ ]]; then
    hyprctl dispatch movetoworkspacesilent special:load
    mpv --wayland-app-id="mpv-bg" --loop --mute --load-scripts=no "$choice" --input-ipc-server=/tmp/mpv-socket-$monitor
    wallust run $choice_thumbnails -s
  fi
  if [[ "$choice" =~ \.(png|jpg)$ ]]; then
    swww img -o $monitor $choice
    wallust run $choice -s
    killall mpv
  fi
fi

killall waybar
sleep 1
waybar -c $HOME/.config/waybar/DP-1.jsonc & disown
waybar -c $HOME/.config/waybar/DP-2.jsonc & disown
exit
