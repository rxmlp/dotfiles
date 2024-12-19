


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
```


4. Install Homebrew, followed by the software listed in the Brewfile.

```zsh
# These could also be in an install script.

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then pass in the Brewfile location...
brew bundle --file ~/.dotfiles/Brewfile

# ...or move to the directory first.
cd ~/.dotfiles && brew bundle
```