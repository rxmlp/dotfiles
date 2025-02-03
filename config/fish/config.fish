
if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting
    set -U EDITOR nano
    set -Ux VISUAL nano
end

starship init fish | source

alias ..="cd .. "

# Colors
alias yay="yay --color=always" # Yay always color

# Alias's for multiple directory listing commands
alias ls='eza --icons --color=always' # Use lsd insead of ls
alias la='eza --icons --color=always -Alh' # show hidden files
alias lk='eza --icons --color=always -lSrh' # sort by size
alias lka='eza --icons --color=always -AlSrh' # sort by size | show hidden files

# Remove all here
alias rmd="/bin/rm  --recursive --force --verbose"

# Pacman logs
alias plog="grep -Ei '(removed|installed|upgraded)' /var/log/pacman.log"

function spf
    set -gx SPF_LAST_DIR "$HOME/.local/state/superfile/lastdir"

    command spf $(pwd)

    if test -f "$SPF_LAST_DIR"
        source "$SPF_LAST_DIR"
        rm -f -- "$SPF_LAST_DIR" > /dev/null
    end
end
