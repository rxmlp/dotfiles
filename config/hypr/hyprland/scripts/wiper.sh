#!/usr/bin/env sh

# Options
prompt='Wiper'
Temp='Temp files'
Cache='Cache'
Screenshot='Purge screenshots'
History='Shell history'
Trash='Trash'
yes='Yes'
no='No'

# Who?
User='You'
Root='Root'

# Rofi CMD
rofi_cmd() {
  rofi -theme-str 'window {height: 280px; width: 250px;}' \
    -dmenu \
    -p "$prompt"
}

# Confirmation CMD
confirm_cmd() {
  rofi -theme-str 'window {height: 200px; width: 250px;}' \
    -dmenu \
    -p 'Who?'
}

# Ask for confirmation
what_user() {
  echo -e "$User\n$Root" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$Temp\n$Cache\n$Screenshot\n$History\n$Trash" | rofi_cmd
}


clear_temp() {
    pkexec sh -c "
    sudo rm -rfv /tmp/*; 
    sudo rm -rfv /var/tmp/*"
}

clear_cache_user() {
    rm -rfv $HOME/.cache/*
}

clear_cache_root() {
    pkexec sh -c "
    sudo rm -rfv root/.cache/*;
    rm -rf /var/cache/*"
}

clear_screenshots() {
    rm -rfv $HOME/Pictures/Screenshots/*
}

clear_history_user() {
    rm -fv $HOME/.bash_history
    rm -fv $HOME/.zsh_history
    rm -fv $HOME/.local/share/fish/fish_history
}

clear_history_root() {
    pkexec sh -c "
    sudo rm -fv /root/.bash_history;
    sudo rm -fv /root/.zsh_history"
}

clear_trash() {
    gio trash --empty
}



# Execute Command
run_cmd() {
  if [[ $1 == '--screenshot' ]]; then
    clear_screenshots
    exit 1
  elif [[ $1 == '--trash' ]]; then
    clear_trash
    exit 1
  elif [[ $1 == '--temp' ]]; then
    clear_temp
    exit 1
  fi

  selected="$(what_user)"
  if [[ "$selected" == "$User" ]]; then
    if [[ $1 == '--cache' ]]; then
      clear_cache_user    
      elif [[ $1 == '--history' ]]; then
      clear_history_user
    fi
  fi

  if [[ "$selected" == "$Root" ]]; then
    if [[ $1 == '--cache' ]]; then
      clear_cache_root
    
    elif [[ $1 == '--history' ]]; then
      clear_history_root

    fi
  fi
}


# Actions
chosen="$(run_rofi)"
case $chosen in
  $Temp)
    run_cmd --temp
    ;;
  $Cache)
    run_cmd --cache
    ;;
  $Screenshot)
    run_cmd --screenshot
    ;;
  $History)
    run_cmd --history
    ;;
  $Trash)
    run_cmd --trash
    ;;
esac
