function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting

end

starship init fish | source
if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
    cat ~/.cache/ags/user/generated/terminal/sequences.txt
end

alias pamcan=pacman

alias ..="cd .. "

# Colors
alias yay="yay --color=always" # Yay always color

# Alias's for multiple directory listing commands
alias ls='eza --icons --color=always' # Use lsd insead of ls
alias la='eza --icons --color=always -Alh' # show hidden files
alias lsa='eza --icons --color=always -aFh' # add colors and file type extensions
alias lx='eza --icons --color=always -lXBh' # sort by extension
alias lk='eza --icons --color=always -lSrh' # sort by size
alias lka='eza --icons --color=always -AlSrh' # sort by size | show hidden files
alias lr='eza --icons --color=always -lRh' # recursive ls
alias lt='eza --icons --color=always -ltrh' # sort by date
alias lf="eza --icons --color=always -l | egrep -v '^d'" # files only
alias ldir="eza --icons --color=always -l | egrep '^d'" # directories only
alias lz="ls *.zip *.tgz *.zst *.gz *.tar *.spk *.jar *.vlt *.txz *.xz" # Search for these files

# Remove all here
alias rmd="/bin/rm  --recursive --force --verbose"

# Pacman logs
alias plog="grep -Ei '(removed|installed|upgraded)' /var/log/pacman.log"