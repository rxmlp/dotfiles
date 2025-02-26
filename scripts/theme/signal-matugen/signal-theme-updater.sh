#!/usr/bin/env bash
# Update signal theme (After changing matugen style)


TEMP=$(mktemp -d --suffix=_SIGNAL) 
SIGNAL_DIR="/usr/lib/signal-desktop/resources"

asar e "${SIGNAL_DIR}/app.asar" ${TEMP}

cp "$HOME/.config/matugen/output/signal-colors.css" "${TEMP}/stylesheets/matugen.css"

if pkexec asar p ${TEMP} "${SIGNAL_DIR}/app.asar"; then
    # Check if Signal is running and kill it if necessary
    if pgrep -f "signal-desktop"; then
      echo "Signal is running, killing process..."
      pkill signal-desktop
    fi
    hyprctl dispatch exec [workspace 10 silent]; signal-desktop --use-tray-icon --enable-features=UseOzonePlatform --ozone-platform=wayland > /dev/null 2>&1 & exit
fi