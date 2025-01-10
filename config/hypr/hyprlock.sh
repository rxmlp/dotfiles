#!/usr/bin/env sh

playerctl pause -a
wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
hyprlock
wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
