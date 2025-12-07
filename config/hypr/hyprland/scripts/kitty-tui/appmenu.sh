#!/bin/bash
# $HLS/kitty/launcher - Multi-path + NoDisplay
mapfile -t lines < <(find ~/.local/share/applications /usr/share/applications -name "*.desktop" 2>/dev/null | sort -u | head -1000 | \
    awk '
    BEGIN { paths[1]="/home/.local/share/applications"; paths[2]="/usr/share/applications"; paths[3]="~/.local/share/flatpak" }
    /^NoDisplay=true$/ { skip=1; next }
    skip { next }
    /^Icon=/ { icon=substr($0, index($0,$2)); gsub(/^[ \t]+|[ \t]+$/, "", icon); next }
    /^Name=/ { name=substr($0, index($0,$2)); gsub(/^[ \t]+|[ \t]+$/, "", name); next }
    END { if (name && icon && length(name) > 1) printf "%s|%s|%s\n", icon, name, FILENAME }
    ' | fzf --delimiter='|' --with-nth=2 --preview 'icat --align left {1} 2>/dev/null' \
           --preview-window right:50% --prompt '🔍 Search apps: ' \
           --header 'Type to fuzzy search • ↑↓ navigate • Enter launch')

[[ -z "${lines[0]}" ]] && exit 1

app_name=$(cut -d'|' -f2 <<< "${lines[0]}")
desktop_file=$(cut -d'|' -f3 <<< "${lines[0]}")
[[ -f "$desktop_file" ]] && exec_line=$(grep '^Exec=' "$desktop_file" | head -1 | cut -d= -f2- | sed 's/%[uUdDF].*//; s/^ *//') && $exec_line
