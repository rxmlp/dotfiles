


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
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig

# Hyprland
ln -s ~/.dotfiles/config/hypr ~/.config/hypr
ln -s ~/.dotfiles/config/hyprlauncher ~/.config/hyprlauncher
ln -s ~/.dotfiles/config/waybar ~/.config/waybar

```
