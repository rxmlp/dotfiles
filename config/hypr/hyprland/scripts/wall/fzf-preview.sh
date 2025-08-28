#!/usr/bin/env bash
set -euo pipefail

file=$(fd --glob -t f "$1.*")
dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}

thumbnail_resolution=1280x720

if [[ $(file --mime-type -b "$file") == video/* ]]; then
  thumbnail_name="${file%.*}.png"
  thumbnail_path=".thumbnails/$thumbnail_name"
  mpv_thumbnail_path=".thumbnails/${thumbnail_name%.png}-mpv.png"
  if [ ! -f "$mpv_thumbnail_path" ]; then
    if [ ! -f "$thumbnail_path" ]; then
      ffmpegthumbnailer -i "$file" -o "$thumbnail_path" -s $thumbnail_resolution
    fi
    composite -gravity southeast $HOME/.config/hypr/hyprland/scripts/wall/.mpv-logo.png "$thumbnail_path" "$mpv_thumbnail_path"
    rm "$thumbnail_path"
  fi
  file="$mpv_thumbnail_path"
fi

if [[ $(file --mime-type -b "$file") == image/png || $(file --mime-type -b "$file") == image/jpeg ]]; then
  thumbnail_name="${file##*/}"
  thumbnail_path=".thumbnails/$thumbnail_name"
  if [ ! -f "$thumbnail_path" ]; then
    magick "$file" -resize "${thumbnail_resolution}^" -gravity center -extent "$thumbnail_resolution" "$thumbnail_path"
  fi
  file="$thumbnail_path"
fi



kitty +kitten icat --clear --transfer-mode=memory --stdin=no --place=$dim@0x0 "$file"