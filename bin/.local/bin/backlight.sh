#!/bin/bash

# You can call this script like this:
# $./backlight.sh up
# $./backlight.sh down

libnotify_id=2

function increase_brightness {
    brightness=$(echo "($(xbacklight)+15)/10*10" | bc)
    xbacklight -set "$brightness%"
}

function decrease_brightness {
    brightness=$(echo "($(xbacklight)-5)/10*10" | bc)
    xbacklight -set "$brightness%"
}

function get_brightness {
    echo "($(xbacklight)+5)/10*10" | bc
}

function send_notification {
    brightness=$(get_brightness)
    icon_name="/usr/share/icons/Faba/48x48/notifications/notification-display-brightness.svg"
    if [ $brightness -lt "10" ]; then
        space="      "
    else
        if [ $brightness -lt "100" ]; then
            space="     "
        else
            space="    "
        fi
    fi
    bar=$(seq -s "─" $(($brightness / 5)) | sed 's/[0-9]//g')
    dunstify -i "$icon_name" -r "$libnotify_id" "$brightness$space$bar" 
}

case $1 in
    up)
        increase_brightness
	send_notification
	;;
    down)
        decrease_brightness
	send_notification
	;;
esac
