#!/usr/bin/env bash
# Install signal theme


TEMP=$(mktemp -d --suffix=_SIGNAL) 
SIGNAL_DIR="/usr/lib/signal-desktop/resources"

# Check if Signal is running and kill it if necessary
if pgrep -f "signal-desktop"; then
  echo "Signal is running, killing process..."
  pkill signal-desktop
fi

asar e "${SIGNAL_DIR}/app.asar" ${TEMP}

cp "$HOME/.config/matugen/output/signal-colors.css" "${TEMP}/stylesheets/matugen.css"

sed -i "1i @import \"matugen.css\";" "${TEMP}/stylesheets/manifest.css"

sudo asar p ${TEMP} "${SIGNAL_DIR}/app.asar"

hyprctl dispatch exec [workspace 10 silent]; signal-desktop --use-tray-icon --enable-features=UseOzonePlatform --ozone-platform=wayland > /dev/null 2>&1 & exit
