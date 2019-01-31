#!/bin/bash

# You can call this script like this:
# $./backlight.sh up
# $./backlight.sh down
# $./backlight.sh status

libnotify_id=2

function increase_brightness {
    max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)
    brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
    target_percent=$(echo "($brightness*100/$max_brightness)+10" | bc)
    if [[ $target_percent -gt 100 ]]; then
        target_percent=100
    fi
    echo "target_percent: $target_percent"
    target_brightness=$(echo "$target_percent*$max_brightness/100" | bc)
    echo $target_brightness > /sys/class/backlight/intel_backlight/brightness
}

function decrease_brightness {
    max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)
    brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
    target_percent=$(echo "($brightness*100/$max_brightness)-10" | bc)
    if [[ $target_percent -lt 0 ]]; then
        target_percent=0
    fi
    echo "target_percent: $target_percent"
    target_brightness=$(echo "$target_percent*$max_brightness/100" | bc)
    echo $target_brightness > /sys/class/backlight/intel_backlight/brightness
}

function get_brightness {
    max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)
    brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
    echo "$brightness*100/$max_brightness" | bc
}

function send_notification {
    brightness=$(get_brightness)
    icon_name="/usr/share/icons/Faba/48x48/notifications/notification-display-brightness.svg"
    if [ $brightness -lt "10" ]; then
        space="     "
    else
        if [ $brightness -lt "100" ]; then
            space="    "
        else
            space="   "
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
    status)
        get_brightness
    ;;
esac
