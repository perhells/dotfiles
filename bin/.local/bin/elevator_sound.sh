#! /bin/bash

# Set cwd to script path
cd "${0%/*}"

PS=$(ps aux | grep mplayer | grep -v grep)

# Stop ding if playing
if [[ "$PS" == *"ding.mp3"* ]]; then
    pkill mplayer 2>&1 > /dev/null
    sleep 0.25
fi

if [ "$#" -ne 1 ]; then
    echo "$# arguments given, expected 1"
    exit 1
fi

PSC=$(ps aux | grep mplayer | grep -v grep | wc -l)

if [ "$PSC" -eq 0 ]; then
    if [ "$1" == "1" ]; then
        mplayer -loop 0 ElevatorSounds/elevator.mp3 2>&1 > /dev/null
    fi
    if [ "$1" == "2" ]; then
        mplayer -loop 0 ElevatorSounds/jeopardy.mp3 2>&1 > /dev/null
    fi
else
    pkill mplayer 2>&1 > /dev/null
    mplayer ElevatorSounds/ding.mp3 2>&1 > /dev/null
fi
