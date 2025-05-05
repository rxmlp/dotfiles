#!/usr/bin/env bash

TEMP=$(mktemp -d --suffix=_SIGNAL) 
SIGNAL_DIR="/usr/lib/signal-desktop/resources"

asar e "${SIGNAL_DIR}/app.asar" ${TEMP}

cp "$HOME/.config/matugen/output/signal-colors.css" "${TEMP}/stylesheets/matugen.css"

# Check if the CSS exists in the manifest
if ! grep -Fxq "@import \"matugen.css\";" "${TEMP}/stylesheets/manifest.css"; then
    # CSS does not exist, so add it at the beginning of the manifest
    sed -i "1i @import \"matugen.css\";" "${TEMP}/stylesheets/manifest.css"
fi

if pkexec asar p ${TEMP} "${SIGNAL_DIR}/app.asar"; then
    # Check if Signal is running and kill it if necessary
    if pgrep -f "signal-desktop"; then
      echo "Signal is running, killing process..."
      pkill signal-desktop
    fi
    hyprctl dispatch exec [workspace 20 silent]; signal-desktop --use-tray-icon --enable-features=UseOzonePlatform --ozone-platform=wayland > /dev/null 2>&1 & exit
fi