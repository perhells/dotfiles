#! /bin/bash

# Set cwd to script path
cd "${0%/*}"

MPLAYER_PROCESSES=$(ps aux | grep mplayer | grep -v grep)

# Stop ding if playing
if [[ "$MPLAYER_PROCESSES" == *"ding.mp3"* ]] || [[ "$MPLAYER_PROCESSES" == *"sad_trombone.mp3"* ]]; then
    pkill mplayer > /dev/null 2>&1
    sleep 0.25
fi

if [ "$#" -ne 1 ]; then
    echo "$# arguments given, expected 1"
    exit 1
fi

MPLAYER_PROCESS_COUNT=$(ps aux | grep mplayer | grep -v grep | wc -l)

if [ "$MPLAYER_PROCESS_COUNT" -eq 0 ]; then
    if [ "$1" == "elevator" ]; then
        mplayer -loop 0 ElevatorSounds/elevator.mp3 > /dev/null 2>&1
    fi
    if [ "$1" == "jeopardy" ]; then
        mplayer -loop 0 ElevatorSounds/jeopardy.mp3 > /dev/null 2>&1
    fi
else
    pkill mplayer 2>&1 > /dev/null
    if [ "$1" == "0" ] || [ "$1" == "elevator" ] || [ "$1" == "jeopardy" ]; then
        mplayer ElevatorSounds/ding.mp3 > /dev/null 2>&1
    else
        mplayer ElevatorSounds/sad_trombone.mp3 > /dev/null 2>&1
    fi
fi
