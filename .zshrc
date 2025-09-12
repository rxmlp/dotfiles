# Define cache directory
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
[[ ! -d "$ZSH_CACHE_DIR" ]] && mkdir -p "$ZSH_CACHE_DIR"

# Move history file to cache directory
export HISTFILE="$ZSH_CACHE_DIR/history"

# Optional: Set history size
export HISTSIZE=10000
export SAVEHIST=10000


#-------Antigen Configuration-------#
source "$HOME/.dotfiles/antigen.zsh"

# Use the Oh My Zsh framework (ensures compatibility)
antigen use oh-my-zsh
  

# Core Oh My Zsh plugins
antigen bundle git
antigen bundle ufw
antigen bundle cp
antigen bundle sudo
antigen bundle history
antigen bundle archlinux
antigen bundle aliases

# External plugins (not part of core Oh My Zsh)
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting


antigen bundle zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Optional: Load a theme (e.g., robbyrussell, or omit for default)
# antigen theme robbyrussell

# Apply all configurations
antigen apply


#-------Theming-------#
export PS1="%m+%d: "

# Install Starship - curl -sS https://starship.rs/install.sh | sh
#eval "$(starship init zsh)"
if [ "$TERM" != "linux" ]; then
  eval "$(starship init zsh)"
fi

#-------Hypr-------#
alias hyprfix-lock='hyprctl --instance 0 "dispatch exec hyprlock"'
alias hyprfix-paper='pkill hyprpaper; sleep 2; hyprpaper > /dev/null 2>&1 & disown'
alias hyprfix-idle='pkill hypridle; sleep 2; hypridle > /dev/null 2>&1 & disown'
alias hyprfix-polkit='systemctl --user restart hyprpolkitagent'
alias hyprfix-cursor='hyprctl setcursor "catppuccin-mocha-dark-cursors" 24 & gsettings set org.gnome.desktop.interface cursor-size 18 & gsettings set org.gnome.desktop.interface cursor-theme "catppuccin-mocha-dark-cursors"'
alias hyprfix-cursor-Xresources='rm ~/.Xresources; echo "Xcursor.size: 18" >> ~/.Xresources && xrdb -merge ~/.Xresources'
alias hyprfix-bar='pkill waybar; uwsm app -- waybar -c $HOME/.config/waybar/DP-1\&2.jsonc & disown'

#-------Bindkeys-------#

# Fix CTRL + C
bindkey -e
# Fix CTRL + arrow
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
# Ignore Volume
bindkey "^[[57439;5u" forward-word
bindkey "^[[57438;5u" backward-word


#-------My cute lil random alias-------#
alias hx='helix'
alias mirror-fix='doas reflector --latest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'
alias sysu='systemctl --user'
alias attack='doas hping3 -S -i u100'
alias flathub='flatpak install flathub --user'
alias pk-clean='\
  echo "Cleaning up Flatpak cache..." && \
  flatpak uninstall --unused --noninteractive && \
  echo "Cleaning up package cache..." && \
  doas pacman -Sc --noconfirm && \
  echo "Killing the orphans..." && \
  doas pacman -Rs $(pacman -Qtdq); \
  echo "System maintenance complete!"'
alias pk-update='doas pacman -Syu --noconfirm && flatpak update --user --noninteractive'
alias ai='sh ~/.sh/ai.sh' # Start and stop ai
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias ffshare='~/.dotfiles/scripts/Random/ffshare.sh'


#-------Logs-------#
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
alias plog="grep -Ei '(removed|installed|upgraded)' /var/log/pacman.log"

# Alias's for multiple directory listing commands
alias ls='eza --icons --color=always' # Use eza insead of ls
alias ld='eza --icons --color=always -d */' # Show dirs only
alias la='eza --icons --color=always -Alh' # Show hidden files
alias lk='eza --icons --color=always -lSrh' # Sort by size
alias lka='eza --icons --color=always -AlSrh' # Sort by size | show hidden files


#-------Files-------#
alias rmd='/bin/rm  --recursive --force --verbose' # Remove a directory and all files

alias home='cd ~' # Go to home
alias cd..='cd ..' # Typo..
alias ..='cd ..' # Go back
alias bd='cd "$OLDPWD"' # Where was I?


# Alias's for archives
mkbz2() {
  if [ -d "$1" ]; then
    tar -cvjf "${1}.tar.bz2" "$1"
  else
    echo "Directory '$1' does not exist."
  fi
}

ex () {
	for archive in "$@"; do
		if [ -f "$archive" ] ; then
			case $archive in
				*.tar.bz2)   tar xvjf $archive    ;;
				*.tar.gz)    tar xvzf $archive    ;;
        		*.tar.xz)    tar xf $archive      ;;				
				*.bz2)       bunzip2 $archive     ;;
				*.rar)       rar x $archive       ;;
				*.gz)        gunzip $archive      ;;
				*.tar)       tar xvf $archive     ;;
				*.tbz2)      tar xvjf $archive    ;;
				*.tgz)       tar xvzf $archive    ;;
				*.zip)       unzip $archive       ;;
				*.Z)         uncompress $archive  ;;
				*.7z)        7z x $archive        ;;
				*)           echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Copy and go to the directory
cpg ()
{
	if [ -d "$2" ];then
		cp "$1" "$2" && cd "$2"
	else
		cp "$1" "$2"
	fi
}

# Move and go to the directory
mvg ()
{
	if [ -d "$2" ];then
		mv "$1" "$2" && cd "$2"
	else
		mv "$1" "$2"
	fi
}

export PATH="$HOME/.local/bin:$PATH"
