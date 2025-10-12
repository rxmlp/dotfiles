#!/usr/bin/env bash

CACHEFILE="$HOME/.cache/application-session-cache"

cache () {
hyprctl clients -j | jq -r '.[].initialClass' | sort -u | while read class; do
  if [ -z "$class" ]; then
    continue
  fi

  # Prefer ~/.local/share/applications
  desktop_path="$HOME/.local/share/applications/${class}.desktop"
  if [ ! -f "$desktop_path" ]; then
    # fallback to /usr/share/applications if not found locally
    desktop_path="/usr/share/applications/${class}.desktop"
  fi

  # Only write if desktop file exists
  if [ -f "$desktop_path" ]; then
    echo "$desktop_path"
  fi
done > "$CACHEFILE"

}

restore() {
  if [ ! -f "$CACHEFILE" ]; then
    echo "Cache file not found: $CACHEFILE"
    exit 1
  fi
  while read -r desktopfile; do
    filename=$(basename "$desktopfile")
    gtk-launch "$filename" >/dev/null 2>&1 &
  done < "$CACHEFILE"
}

case "$1" in
  cache)
    cache
    ;;
  restore)
    restore
    ;;
  *)
    echo "Usage: $0 {cache|restore}"
    exit 1
    ;;
esac