#!/usr/bin/env sh


pkill waybar; sleep 1
waybar -c $HOME/.config/waybar/DP-1.jsonc & disown
waybar -c $HOME/.config/waybar/DP-2.jsonc & disown
exit
