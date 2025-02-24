#!/usr/bin/env sh

# Ask for confirmations
read -p "Apply Catppuccin mocha theme to Signal? (y/n) " signal_confirmation
signal_confirmation=${signal_confirmation,,}

read -p "Apply Catppuccin mocha theme to Steam? (y/n) " steam_confirmation
steam_confirmation=${steam_confirmation,,}


# Execute Signal Theme
if [ "$signal_confirmation" = 'y' ]; then
    FLAVOR=mocha
    SIGNAL_TEMP=$(mktemp -d --suffix=_SIGNAL)
    SIGNAL_DIR="/usr/lib/signal-desktop/resources"
    if pgrep -f "signal-desktop"; then
        echo "Signal is running, killing process..."
        pkill signal-desktop
    fi
    echo "Extracting Signal Desktop app.asar to temporary directory..."
    asar e "${SIGNAL_DIR}/app.asar" ${SIGNAL_TEMP}

    echo "Downloading Catppuccin ${FLAVOR} theme for Signal Desktop..."
    curl "https://raw.githubusercontent.com/CalfMoon/signal-desktop/refs/heads/main/themes/catppuccin-${FLAVOR}.css" -o "${SIGNAL_TEMP}/stylesheets/catppuccin-${FLAVOR}.css"

    echo "Modifying Signal Desktop manifest.css..."
    sed -i "1i @import \"catppuccin-${FLAVOR}.css\";" "${SIGNAL_TEMP}/stylesheets/manifest.css"

    echo "Applying Catppuccin ${FLAVOR} theme to Signal Desktop..."
    sudo asar p ${SIGNAL_TEMP} "${SIGNAL_DIR}/app.asar"
    echo "Theme applied successfully."
    hyprctl dispatch exec [workspace 10 silent]; signal-desktop --use-tray-icon --enable-features=UseOzonePlatform --ozone-platform=wayland > /dev/null 2>&1 & exit
else
    echo "Signal skipped."
fi

# Execute Steam Theme
if [ "$steam_confirmation" = 'y' ]; then
    STEAM_TEMP=$(mktemp -d --suffix=_STEAM)
    STEAM_FLAVOR="-c catppuccin-mocha"
    echo "Downloading Steam theme installer..."
    git clone https://github.com/tkashkin/Adwaita-for-Steam ${STEAM_TEMP}
    echo "Download complete."
    echo "Applying Catppuccin theme to Steam..."
    cd ${STEAM_TEMP}
    "./install.py" ${STEAM_FLAVOR}
    echo "Theme applied successfully."
    echo "Applied Catppuccin theme to Steam"
else
    echo "Steam skipped."
fi