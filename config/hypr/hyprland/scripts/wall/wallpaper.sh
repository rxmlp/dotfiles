#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR

#source "$HLS/moni-env.sh" && get_monitors
wall_dir="$HOME/Pictures/Wallpapers"
cd "$wall_dir"
choices=$(fd . --type f -d 1 -e png -e jpg --format {/.} | shuf | fzf --cycle --preview='$HLS/wall/fzf-preview.sh {}' --preview-window=right,70% --info=hidden --color prompt:green,pointer:green,current-bg:-1,current-fg:green,gutter:-1,border:bright-black,current-hl:red,hl:red)
choice=$(fd "$choices" --absolute-path)
monitor_name=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

save_to_hyprpaper_conf() {
  local config="$HOME/.config/hypr/hyprpaper.conf"
  local temp_config=$(mktemp)

  local in_wallpaper_block=false
  local current_monitor=""
  local block_content=""

  # Read existing config if it exists
  if [[ -f "$config" ]]; then
    while IFS= read -r line; do
      if [[ "$line" =~ ^wallpaper[[:space:]]*\{ ]]; then
        in_wallpaper_block=true
        current_monitor=""
        block_content="$line"
        continue
      fi

      if [[ "$in_wallpaper_block" == true ]]; then
        block_content+=$'\n'"$line"

        if [[ "$line" =~ monitor[[:space:]]*=[[:space:]]*(.+) ]]; then
          current_monitor="${BASH_REMATCH[1]}"
        fi

        if [[ "$line" =~ ^\} ]]; then
          in_wallpaper_block=false

          # Skip this block if it's the monitor we're updating
          if [[ "$current_monitor" != "$monitor_name" ]]; then
            echo "$block_content" >> "$temp_config"
          fi
        fi
      else
        echo "$line" >> "$temp_config"
      fi
    done < "$config"
  fi

  # Append the new/updated wallpaper block
  cat <<EOF >> "$temp_config"
wallpaper {
    monitor = $monitor_name
    path = $choice
    fit_mode = cover
}
EOF

  mv "$temp_config" "$config"
}


if [[ "$choice" =~ \.(png|jpg)$ ]]; then
save_to_hyprpaper_conf
hyprctl hyprpaper wallpaper $monitor_name,"$choice"
monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .description')
monitor_primary=$(grep '^\$monitor_primary = desc:' "$HL/conf/devices.conf" | sed -E 's/^\$monitor_primary = desc:(.*)$/\1/')
if [[ "$monitor" = "$monitor_primary" ]]; then
    matugen -c ~/.config/matugen/matugen.toml image "$choice"
    if [[ "$(printenv hyprlockwall)" = "on" ]]; then
    sed -i "s|\$hyprlockwall = .*|\$hyprlockwall = $choice|" $HOME/.config/hypr/theme.conf
    fi
fi
fi
