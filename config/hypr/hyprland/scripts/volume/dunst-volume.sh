#!/usr/bin/env bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute
theme=Papirus-Dark

function get_volume {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100}'
}

function get_mute {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $3}'
}

function send_notification {
    volume=`get_volume`
    mute=`get_mute`
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
#bar=$(seq -s "─" $(($volume/5)) | sed 's/[0-9]//g')
if [ "$volume" = "0" ]; then
    icon_name="/usr/share/icons/$theme/symbolic/status/audio-volume-muted-symbolic.svg"
    else

	if [ "$volume" -lt "10" ]; then
	    icon_name="/usr/share/icons/$theme/symbolic/status/audio-volume-low-symbolic.svg"
        else

        if [ "$volume" -lt "30" ]; then
            icon_name="/usr/share/icons/$theme/symbolic/status/audio-volume-low-symbolic.svg"
            else

            if [ "$volume" -lt "70" ]; then
                icon_name="/usr/share/icons/$theme/symbolic/status/audio-volume-medium-symbolic.svg"
                else

                    icon_name="/usr/share/icons/$theme/symbolic/status/audio-volume-high-symbolic.svg"
            fi
        fi
    fi
fi

bar=$(seq -s "─" $(($volume/5)) | sed 's/[0-9]//g')

    # Debugging statements
    echo "Volume: $volume"
    echo "Bar: $bar"
    echo "Icon Name: $icon_name"

# Send the notification
dunstify "$volume"" ""$bar" -i "$icon_name" --replace=340716

}

case $1 in
    up)
	# Set the volume on (if it was muted)
	wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 > /dev/null
	# Up the volume (+ 5%)
	wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ > /dev/null
	send_notification
	;;
    down)
	wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 > /dev/null
	wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- > /dev/null
	send_notification
	;;
    mute)
    	# Toggle mute
	wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle > /dev/null
	if [ "$(get_mute)" = "[MUTED]" ] ; then
    dunstify -i "/usr/share/icons/$theme/symbolic/status/audio-volume-muted-symbolic.svg" "Mute" --replace=340716
	else
	send_notification
	fi
	;;
esac