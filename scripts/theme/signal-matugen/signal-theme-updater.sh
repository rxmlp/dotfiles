#!/usr/bin/env sh
# Update signal theme (After changing matugen style)


TEMP=$(mktemp -d --suffix=_SIGNAL) 
SIGNAL_DIR="/usr/lib/signal-desktop/resources"

# Check if Signal is running and kill it if necessary
if pgrep -f "signal-desktop"; then
  echo "Signal is running, killing process..."
  pkill signal-desktop
fi

asar e "${SIGNAL_DIR}/app.asar" ${TEMP}

cp "$HOME/.config/matugen/output/signal-colors.css" "${TEMP}/stylesheets/matugen.css"

sudo asar p ${TEMP} "${SIGNAL_DIR}/app.asar"

hyprctl dispatch exec [workspace 10 silent]; signal-desktop --use-tray-icon --enable-features=UseOzonePlatform --ozone-platform=wayland > /dev/null 2>&1 & exit
