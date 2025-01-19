#!/usr/bin/env sh

wallpapers="$HOME/.config/hypr/wall/"
prompt='Select Wallpaper'
win_width='600px'
win_height='400px'

rofi_cmd() {
  rofi -dmenu \
    -theme-str "window {width: $win_width;}" \
    -theme-str "window {height: $win_height;}" \
    -p "$prompt"
}

random_wallpaper() {
    wallpaper=$(find "$wallpapers" -type f | shuf -n 1)
    hyprctl hyprpaper preload "$wallpaper"
    hyprctl hyprpaper wallpaper "DP-1,$wallpaper"
}

select_wallpaper(){
    files=$(find "$wallpapers" -type f -printf '%f\n')
    random=Random
    options="$random\n$files"
    wallpaper=$(echo -e "$options" | rofi_cmd)

    if [[ $wallpaper == "Random" ]]; then
        random_wallpaper
    elif [[ $wallpaper == "" ]]; then
        exit
    else
        set_wallpaper "$wallpaper"
    fi
}

set_wallpaper(){
    hyprctl hyprpaper preload "$wallpapers""$wallpaper"
    hyprctl hyprpaper wallpaper "DP-1,"$wallpapers"$wallpaper"
}

select_wallpaper
