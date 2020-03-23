#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Expected exactly one argument!"
    exit 1
fi

if [ $1 == 'HDMI-0' ]; then
    echo "Using HDMI-0 as main output!"
    xrandr --fb 1920x1080 --output DVI-I-1 --auto --scale-from 1920x1080 --output HDMI-0 --mode 1920x1080 --scale 1x1 --same-as DVI-I-1
else
    if [ $1 == 'DVI-I-1' ]; then
        echo "Using DVI-I-1 as main output!"
        xrandr --fb 2560x1600 --output DVI-I-1 --auto --scale 1x1 --output HDMI-0 --mode 1920x1080 --scale-from 2560x1600 --same-as DVI-I-1
    else
        echo "Invalid output: $1"
        echo "Expected HDMI-0 or DVI-I-1"
        exit 1
    fi
fi

~/.config/polybar/mirror.sh
