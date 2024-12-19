#!/usr/bin/env bash
playerctl pause -a
wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
hyprlock
wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
