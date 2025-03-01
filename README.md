
# These might be a mess but ehh they work for me
Don't come crying if these dotfiles are shit, I made it so it works for my day to day.

This setup was made for dual monitor, so if you want to use only one monitor this might not work perfectly. It for sure won't work as intended.
As I am also changing the setup a lot of you don't read changes before applying they might not work. Missing apps ect. That is usually not a problem but you have been warned.

![DP-1](DP-1.jpg)
![DP-2](DP-2.jpg)


1. Kinda need git for to clone and yay for last
```zsh
sudo pacman -S yay git
```
```zsh
git clone https://github.com/rxmlp/dotfiles.git ~/.dotfiles
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
ln -s ~/.dotfiles/config/hypr ~/.config/hypr
ln -s ~/.dotfiles/config/waybar ~/.config/waybar
ln -s ~/.dotfiles/config/dunst ~/.config/dunst
ln -s ~/.dotfiles/config/rofi ~/.config/rofi
ln -s ~/.dotfiles/config/superfile ~/.config/superfile
ln -s ~/.dotfiles/config/matugen ~/.config/matugen
ln -s ~/.dotfiles/config/qt6ct ~/.config/qt6ct
```

4.  Installing a few things...

Hypr
```zsh
yay -S hyprland-git hyprlock-git hypridle-git hyprutils-git hyprgraphics-git hyprcursor-git hyprland-qt-support-git hyprwayland-scanner-git hyprpicker-git xdg-desktop-portal-hyprland-git hyprland-qtutils-git hyprland-protocols-git hyprsunset-git aquamarine-git hyprsysteminfo-git hyprpolkitagent-git ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite libxrender pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm glaze xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus xcb-util-errors qt6ct
```
Xdg
```zsh 
yay -S xdg-desktop-portal-gtk xdg-desktop-portal-wlr
```
qt
```zsh 
yay -S papirus-icon-theme kvantum
```
Wallpaper stuff
```zsh
yay -S swww mpv matugen-bin
```
Bar, launcher, volume, notifications, clip & record
```zsh 
yay -S waybar waybar-module-pacman-updates-git dunst rofi-wayland networkmanager bluez bluez-tools bluez-utils wl-clipboard clipman grimblast-git wf-recorder pavucontrol
```
Terminal
```zsh 
yay -S kitty zsh eza nvtop fastfetch ghostty fish
```
Filemanagement
```zsh 
yay -S pcmanfm-qt superfile pinta gimp libreoffice-still vscodium
```
Dependencies & Scripts need
```zsh
yay -S jq sassc fd fzf imagemagick ffmpegthumbnailer ttf-jetbrains-mono-nerd socat
```

5. Installing some plugins

Install hyprland plugins
```zsh
hyprpm add https://github.com/hyprwm/hyprland-plugins
```
Enable used plugins
```zsh
hyprpm enable xtra-dispatchers
hyprpm enable hyprexpo
hyprpm enable hyprwinwrap
```
