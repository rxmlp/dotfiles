#!/usr/bin/env bash
set -euo pipefail

file=$(fd --glob -t f "$1.*")
dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}
thumbnail_resolution=1280x720
thumbnail_dir="$HOME/.cache/wall-thumbnails"

# Create thumbnail directory if it doesn't exist
mkdir -p "$thumbnail_dir"

if [[ $(file --mime-type -b "$file") == image/png || $(file --mime-type -b "$file") == image/jpeg ]]; then
  thumbnail_name="${file##*/}"
  thumbnail_path="$thumbnail_dir/$thumbnail_name"

  if [ ! -f "$thumbnail_path" ]; then
    magick "$file" -resize "${thumbnail_resolution}^" -gravity center -extent "$thumbnail_resolution" "$thumbnail_path"
  fi

  file="$thumbnail_path"
fi

kitty +kitten icat --clear --transfer-mode=memory --stdin=no --place=$dim@0x0 "$file"
