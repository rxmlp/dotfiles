

# Chaotic aur (optional)
```# We start by retrieving the primary key to enable the installation of our keyring and mirror list:
```
```zsh
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
```
```# Then, we append (adding at the end) the following to /etc/pacman.conf:
```
```zsh
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
```


1. Install essentials

```zsh
sudo pacman -S yay zsh git
```

```zsh
# Set zsh as default
chsh -s $(which zsh)
```

2.  Clone repo into new hidden directory.

```zsh
# Use SSH (if set up)...
git clone git@github.com:rxmlp/dotfiles.git ~/.dotfiles
```

```zsh
# ...or use HTTPS and switch remotes later.
git clone https://github.com/rxmlp/dotfiles.git ~/.dotfiles
```


3. Create symlinks in the Home directory to the real files in the repo.

```zsh
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/config/kitty ~/.config/kitty
ln -s ~/.dotfiles/config/alacritty ~/.config/alacritty
ln -s ~/.dotfiles/config/neofetch ~/.config/neofetch
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig

# Hyprland
ln -s ~/.dotfiles/config/hypr ~/.config/hypr
ln -s ~/.dotfiles/config/hyprlauncher ~/.config/hyprlauncher
ln -s ~/.dotfiles/config/waybar ~/.config/waybar
ln -s ~/.dotfiles/config/swayosd ~/.config/swayosd
ln -s ~/.dotfiles/config/swaync ~/.config/swaync
ln -s ~/.dotfiles/config/rofi ~/.config/rofi


```
