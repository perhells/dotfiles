#!/usr/bin/env bash

# Set cwd to script path
cd "${0%/*}"

count=$(ls Soundeffects/*.mp3 | wc -l)
num=$(( ( RANDOM % count ) + 1 ))
sound=$(ls Soundeffects/*.mp3 | tail -n "$num"  | head -n 1)

mplayer "$sound"
