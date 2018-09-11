#!/usr/bin/env bash

# Set cwd to script path
cd "${0%/*}"

sounds=$(find "Soundeffects/" -name "*.mp3" -or -name "*.wav")
count=$(echo "$sounds" | wc -l)
num=$(( ( RANDOM % count ) + 1 ))
sound=$(echo "$sounds" | tail -n "$num"  | head -n 1)

mplayer "$sound"
