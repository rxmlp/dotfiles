#!/usr/bin/env bash



    STEAM_TEMP=$(mktemp -d --suffix=_STEAM)
    STEAM_FLAVOR="-c matugen"

    # Get the steam theme installer
    git clone https://github.com/tkashkin/Adwaita-for-Steam ${STEAM_TEMP}

    # Get the matugen theme imported
    mkdir ${STEAM_TEMP}/adwaita/colorthemes/matugen
    cp ~/.config/matugen/output/steam-colors.css ${STEAM_TEMP}/adwaita/colorthemes/matugen/matugen.css

    cd ${STEAM_TEMP}
    "./install.py" ${STEAM_FLAVOR}

    if pgrep -f "steam"; then
      pkill steam
    fi