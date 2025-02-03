#!/usr/bin/env sh

RESET_COLOR="\033[0m"
TEXT_GREEN="\033[92m"

# Ask for confirmations
read -p "Clear temp (y/n) " clear_temp_confirmation
clear_temp_confirmation=${clear_temp_confirmation,,}

read -p "Clear cache (y/n) " clear_cache_confirmation
clear_cache_confirmation=${clear_cache_confirmation,,}

read -p "Clear trash (y/n) " clear_trash_confirmation
clear_trash_confirmation=${clear_trash_confirmation,,}


if [ "$clear_temp_confirmation" = 'y' ]; then
    rm -rfv /tmp/*  > /dev/null 2>&1
    rm -rfv /var/tmp/* > /dev/null 2>&1
    echo -e "${TEXT_GREEN}Temp deleted"
fi

if [ "$clear_cache_confirmation" = 'y' ]; then
    rm -rfv $HOME/.cache/* > /dev/null 2>&1
    echo -e "Cache deleted"
fi

if [ "$clear_trash_confirmation" = 'y' ]; then
    gio trash --empty
    echo -e "${TEXT_GREEN}Trashed deleted${RESET_COLOR}"
fi