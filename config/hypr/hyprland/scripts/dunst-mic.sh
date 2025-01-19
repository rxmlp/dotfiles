#!/usr/bin/env sh

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

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
    icon_name="/usr/share/icons/Dracula/symbolic/status/microphone-sensitivity-none-symbolic.svg"
    else

	if [ "$volume" -lt "10" ]; then
	    icon_name="/usr/share/icons/Dracula/symbolic/status/microphone-sensitivity-none-symbolic.svg"
        else

        if [ "$volume" -lt "30" ]; then
            icon_name="/usr/share/icons/Dracula/symbolic/status/microphone-sensitivity-low-symbolic.svg"
            else

            if [ "$volume" -lt "70" ]; then
                icon_name="/usr/share/icons/Dracula/symbolic/status/microphone-sensitivity-medium-symbolic.svg"
                else

                    icon_name="/usr/share/icons/Dracula/symbolic/status/microphone-sensitivity-high-symbolic.svg"
            fi
        fi
    fi
fi

bar=$(seq -s "─" $(($volume/5)) | sed 's/[0-9]//g')
# Send the notification
dunstify "$volume"" ""$bar" -i "$icon_name" --replace=340716

}

case $1 in
    up)
	# Set the volume on (if it was muted)
	wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0 > /dev/null
	# Up the volume (+ 5%)
	wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+ > /dev/null
	send_notification
	;;
    down)
	wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0 > /dev/null
	wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%- > /dev/null
	send_notification
	;;
    mute)
    	# Toggle mute
	wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle > /dev/null
	if get_mute ; then
    dunstify -i "/usr/share/icons/Dracula/symbolic/status/status/microphone-sensitivity-none-symbolic.svg" "Mute" --replace=340716
	else
	send_notification
	fi
	;;
esac