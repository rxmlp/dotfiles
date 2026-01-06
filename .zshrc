# Define cache directory
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
[[ ! -d "$ZSH_CACHE_DIR" ]] && mkdir -p "$ZSH_CACHE_DIR"

# Move history file to cache directory
export HISTFILE="$ZSH_CACHE_DIR/history"

# Optional: Set history size
export HISTSIZE=10000
export SAVEHIST=10000


#-------Antigen Configuration-------#
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"


zinit load mfaerevaag/wd

# OhMyZsh
zinit snippet OMZP::archlinux
zinit snippet OMZP::aliases
zinit snippet OMZP::extract
zinit snippet OMZP::history

# Zsh Community
zinit load zsh-users/zsh-autosuggestions
zinit load zsh-users/zsh-syntax-highlighting
zinit load zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


#-------Theming-------#
export PS1="%m+%d: "

# Install Starship - curl -sS https://starship.rs/install.sh | sh
#eval "$(starship init zsh)"
if [ "$TERM" != "linux" ]; then
  eval "$(starship init zsh)"
fi


#-------Exports-------#
export EDITOR=helix
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HLS/bin:$PATH"


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
alias dh='doas helix'
alias sysu='systemctl --user'
alias attack='doas hping3 -S -i u100'
#alias sn='hyprshutdown -p "systemctl poweroff"'
sn() {
    if [[ "$1" == "-r" ]]; then
        nohup hyprshutdown -p "systemctl reboot" >/dev/null 2>1 &
    else
        nohup hyprshutdown -p "systemctl poweroff" >/dev/null 2>&1 &
    fi
}


#-------Logs-------#
alias logs="doas find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# Alias's for multiple directory listing commands
alias ls='eza --icons --color=always' # Use eza insead of ls
alias lt='eza --icons --color=always --tree' # Tree view
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
tarit() {
  if [ -d "$1" ]; then
    tar -cvjf "${1}.tar.bz2" "$1"
  else
    echo "Directory '$1' does not exist."
  fi
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

# For terminal to follow yazi path
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
