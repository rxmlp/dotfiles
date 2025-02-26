#!/usr/bin/env bash
file=$(fd --glob -t f "$1.*")
dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}



if [[ $(file --mime-type -b "$file") == video/* ]]; then
  thumbnail_name="${file%.*}.png"
  thumbnail_path=".thumbnails/$thumbnail_name"
  mpv_thumbnail_path=".thumbnails/${thumbnail_name%.png}-mpv.png"
  if [ ! -f "$mpv_thumbnail_path" ]; then
    if [ ! -f "$thumbnail_path" ]; then
      ffmpegthumbnailer -i "$file" -o "$thumbnail_path" -s 1280x720
    fi
    composite -gravity southeast $HOME/.dotfiles/config/hypr/wall/.mpv-logo.png "$thumbnail_path" "$mpv_thumbnail_path"
    rm "$thumbnail_path"
  fi
  file="$mpv_thumbnail_path"
fi



kitty +kitten icat --clear --transfer-mode=memory --stdin=no --place=$dim@0x0 "$file"