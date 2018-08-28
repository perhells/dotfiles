#!/bin/bash

set -e
set -o nounset
set -o pipefail

LIBNOTIFY_ID=5
CURRENT_MONITOR=$(xrandr | grep " primary " | cut -f 1 -d " ")
INTERNAL_MONITOR=$(xrandr | grep "LVDS-[0-9]* connected" | cut -f 1 -d " ")

if EXTERNAL_MONITOR=$(xrandr | grep "VGA-[0-9]* connected" | cut -f 1 -d " "); then
    if [ "$CURRENT_MONITOR" == "$INTERNAL_MONITOR" ]; then
        MSG="$EXTERNAL_MONITOR and $INTERNAL_MONITOR are connected, using $EXTERNAL_MONITOR"
        echo "$MSG"
        xrandr --output "$EXTERNAL_MONITOR" --auto --primary --output "$INTERNAL_MONITOR" --off
    else
        MSG="$EXTERNAL_MONITOR and $INTERNAL_MONITOR are connected, using $INTERNAL_MONITOR"
        echo "$MSG"
        xrandr --output "$INTERNAL_MONITOR" --auto --primary --output "$EXTERNAL_MONITOR" --off
    fi
    dunstify -i /usr/share/icons/Faba/48x48/devices/video-display.svg -r "$LIBNOTIFY_ID" "$MSG"
else
    MSG="No monitor connected on VGA, using $INTERNAL_MONITOR"
    if [ "$CURRENT_MONITOR" != "$INTERNAL_MONITOR" ]; then
        xrandr --output "$INTERNAL_MONITOR" --auto --primary
    fi
    dunstify -i /usr/share/icons/Faba/48x48/devices/video-display.svg "$MSG"
fi

~/.fehbg
