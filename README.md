
# These might be a mess but ehh they work for me
Don't come crying if these dotfiles are shit, I made it so it works for my day to day.


1. Kinda need git for to clone and yay for last
```zsh
sudo pacman -S yay git
```
```zsh
git clone git@github.com:rxmlp/dotfiles.git ~/.dotfiles
```


2. Chaotic aur (optional)

We start by retrieving the primary key to enable the installation of our keyring and mirror list:
```zsh
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
```

Then, we append (adding at the end) the following to /etc/pacman.conf:
```zsh
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
```


3. Create symlinks in the Home directory to the real files in the repo.

```zsh
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.nanorc ~/.nanorc
ln -s ~/.dotfiles/config/kitty ~/.config/kitty
ln -s ~/.dotfiles/config/fastfetch ~/.config/fastfetch
ln -s ~/.dotfiles/config/ghostty ~/.config/ghostty
ln -s ~/.dotfiles/config/fish ~/.config/fish
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig

# Hyprland
ln -s ~/.dotfiles/config/hypr ~/.config/hypr
ln -s ~/.dotfiles/config/fuzzel ~/.config/fuzzel
ln -s ~/.dotfiles/config/waybar ~/.config/waybar
ln -s ~/.dotfiles/config/swayosd ~/.config/swayosd
ln -s ~/.dotfiles/config/swaync ~/.config/swaync
ln -s ~/.dotfiles/config/rofi ~/.config/rofi
```


4.  Installing a few things...

```zsh
yay -S hyprland-git hyprlock-git hypridle-git hyprutils-git hyprgraphics-git hyprcursor-git hyprwayland-scanner-git hyprpicker-git xdg-desktop-portal-hyprland-git hyprland-qtutils-git xdg-desktop-portal-gtk xdg-desktop-portal-wlr-git wl-clipboard clipman waybar waybar-module-pacman-updates-git swaync swayosd-git rofi-wayland kitty zsh jq grim slurp grimblast-git hyprpaper-git qt5ct sddm catppuccin-cursors-mocha fuzzel hyprlauncher-bin nvtop
```

Set zsh as default
```zsh
chsh -s $(which zsh)
```