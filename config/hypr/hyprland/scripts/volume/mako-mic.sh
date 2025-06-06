#!/usr/bin/env bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute
theme=Papirus-Dark

function get_volume {
    wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print $2*100}'
}

function get_mute {
    wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print $3}'
}

function send_notification {
    volume=`get_volume`
    mute=`get_mute`
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
#bar=$(seq -s "─" $(($volume/5)) | sed 's/[0-9]//g')
if [ "$volume" = "0" ]; then
    icon_name="$HOME/.icons/$theme/16x16/symbolic/status/microphone-sensitivity-none-symbolic.svg"
    else

	if [ "$volume" -lt "10" ]; then
	    icon_name="$HOME/.icons/$theme/16x16/symbolic/status/microphone-sensitivity-none-symbolic.svg"
        else

        if [ "$volume" -lt "30" ]; then
            icon_name="$HOME/.icons/$theme/16x16/symbolic/status/microphone-sensitivity-low-symbolic.svg"
            else

            if [ "$volume" -lt "70" ]; then
                icon_name="$HOME/.icons/$theme/16x16/symbolic/status/microphone-sensitivity-medium-symbolic.svg"
                else

                    icon_name="$HOME/.icons/$theme/16x16/symbolic/status/microphone-sensitivity-high-symbolic.svg"
            fi
        fi
    fi
fi

bar=$(seq -s "─" $(($volume/5)) | sed 's/[0-9]//g')
# Send the notification
notify-send --app-name volume -h string:x-canonical-private-synchronous:340716 "$volume" "$bar" -i "$icon_name"

}

case $1 in
    up)
	wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0 > /dev/null
	wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+ > /dev/null
	send_notification
	;;
    down)
	wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0 > /dev/null
	wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%- > /dev/null
	send_notification
	;;
    mute)
	wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle > /dev/null
	if [ "$(get_mute)" = "[MUTED]" ] ; then
    notify-send --app-name volume -h string:x-canonical-private-synchronous:340716 "$HOME/.icons/$theme/16x16/symbolic/status/microphone-sensitivity-none-symbolic.svg" "Mute"
	else
	send_notification
	fi
	;;
esac