#-------Theming-------#

# Install Starship - curl -sS https://starship.rs/install.sh | sh
#eval "$(starship init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh" # Where is $ZSH?
ZSH_THEME="powerlevel10k/powerlevel10k" # Theme for typing area...


#-------oh-my-zsh-------#
zstyle ':omz:update' mode reminder  # mode can be reminder, auto or disabled
# zstyle ':omz:update' frequency 7 # You may want this if using auto update. auto-update (in days).

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )


CASE_SENSITIVE="true" # Case-sensitive completion.

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Ohmyzsh plugins
plugins=(zsh-autosuggestions history-substring-search zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"


#-------Hypr-------#
alias hyprfix-lock='hyprctl --instance 0 "dispatch exec hyprlock"'
alias hyprfix-paper='pkill hyprpaper; sleep 2; hyprpaper > /dev/null 2>&1 & disown'
alias hyprfix-idle='pkill hypridle; sleep 2; hypridle > /dev/null 2>&1 & disown'
alias hyprfix-polkit='systemctl --user restart hyprpolkitagent'
alias hyprfix-cursor='hyprctl setcursor "catppuccin-mocha-dark-cursors" 24 & gsettings set org.gnome.desktop.interface cursor-size 18 & gsettings set org.gnome.desktop.interface cursor-theme "catppuccin-mocha-dark-cursors"'
alias hyprfix-cursor-Xresources='rm ~/.Xresources; echo "Xcursor.size: 18" >> ~/.Xresources && xrdb -merge ~/.Xresources'

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
alias attack='doas hping3 -S -i u100'
alias flathub='flatpak install flathub --user'
alias pk-clean='\
  echo "Removing orphaned packages..." && \
  yay -Yc --noconfirm && \
  echo "Cleaning up package cache..." && \
  doas pacman -Sc --noconfirm && \
  echo "Cleaning up Flatpak cache..." && \
  flatpak uninstall --unused --noninteractive && \
  echo "System maintenance complete!"'
alias pk-update='yay -Syu --noconfirm && flatpak update --noninteractive'
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


#-------SSH-------#
alias kssh="kitty +kitten ssh"
# KITTY - alias to be able to use kitty features when connecting to remote servers(e.g use tmux on remote server)
# Alias's for SSH
# alias SERVERNAME='ssh YOURWEBSITE.com -l USERNAME -p PORTNUMBERHERE'

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

# Added by zap installation script
PATH=$PATH:$HOME/.local/bin/
alias zap-git='zap install --github --from'

#-------EXPORTS-------#
# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
