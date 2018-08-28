#!/bin/bash

libnotify_id=4
icon_name="/usr/share/icons/Faba/48x48/devices/input-touchpad.svg"

declare -i ID
ID=`xinput list | grep -Eio 'touchpad\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}'`
declare -i STATE
STATE=`xinput list-props $ID|grep 'Device Enabled'|awk '{print $4}'`
if [ $STATE -eq 1 ]
then
    xinput disable $ID
    # echo "Touchpad disabled."
    unclutter -idle 0 &
    dunstify "Touchpad disabled" -i "$icon_name" -r "$libnotify_id"
else
    xinput enable $ID
    # echo "Touchpad enabled."
    pkill unclutter
    dunstify "Touchpad enabled" -i "$icon_name" -r "$libnotify_id"
fi
