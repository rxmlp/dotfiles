#!/usr/bin/env bash

# Ask for confirmations
read -p "Get Papirus icons?? (y/n) " papirus_icons_confirmation
papirus_icons_confirmation=${papirus_icons_confirmation,,}

read -p "Get GTK theme?? (y/n) " gtk_confirmation
gtk_confirmation=${gtk_confirmation,,}

read -p "Get Cursor?? (y/n) " cursor_confirmation
cursor_confirmation=${cursor_confirmation,,}


# Get Papirus Icons
if [ "$papirus_icons_confirmation" = 'y' ]; then
    echo "Downloading Papirus icons"
    yay -S papirus-icon-theme
    gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark
    echo "Applied Papirus icons"
else
    echo "Papirus icons skipped"
fi

# Get GTK theme
if [ "$gtk_confirmation" = 'y' ]; then
    GTK_TEMP=$(mktemp -d --suffix=_GTK)
    GTK_FLAVOR="-t red"
    if [ ! -d "$HOME/.themes" ]; then
        echo "Creating $HOME/.themes directory..."
        mkdir "$HOME/.themes"
    fi
    echo "Downloading GTK theme installer"
    git clone https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme.git ${GTK_TEMP}
    echo "Download complete."
    echo "Applying Catppuccin theme to GTK"
    cd ${GTK_TEMP}/themes
    "./install.sh" ${GTK_FLAVOR}
    echo "Theme installed"
    gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-Red-Dark"
    echo "Applied GTK theme"
else
    echo "GTK skipped."
fi

if [ "$cursor_confirmation" = 'y' ]; then
    CURSOR_TEMP=$(mktemp -d --suffix=_CURSOR)
    CURSOR_FLAVOR="catppuccin-mocha-dark-cursors"
    echo "Downloading cursors"
    wget -O ${CURSOR_TEMP}/${CURSOR_FLAVOR}.zip https://github.com/catppuccin/cursors/releases/latest/download/${CURSOR_FLAVOR}.zip
    cd ${CURSOR_TEMP}
    echo "Unzipping cursor"
    unzip ${CURSOR_FLAVOR}.zip
    if [ ! -d "$HOME/.icons" ]; then
        echo "Creating $HOME/.icons directory..."
        mkdir "$HOME/.icons"
    fi
    echo "Moving cursor"
    mv ${CURSOR_TEMP}/${CURSOR_FLAVOR} $HOME/.icons
    echo "Applied Cursor"
    gsettings set org.gnome.desktop.interface cursor-theme ${CURSOR_FLAVOR}
else
    echo "Cursor skipped"
fi
