#!/bin/bash
B='#00000000'  # blank
C='#ffffff22'  # clear ish
D='#ffffff66'  # clear ish
T='#ffffffcc'  # clear ish
W='#88000044'  # wrong
V='#ffffff44'  # verifying

screenarea=$(xrandr --current | grep -oP '(?<=current )\d+ x \d+')
screenarea=${screenarea// /}

background="$HOME/Pictures/lockscreen.png"
background_resized="$HOME/Pictures/lockscreen_$screenarea.png"

if [ -f "$background_resized" ] && [[ $background -ot $background_resized ]]; then
    echo "Resized background exists and is older than background, skipping resize!"
else
    echo "Resizing background..."
    convert "$background" -scale "$screenarea^" -gravity center -extent "$screenarea" "$background_resized"
fi

i3lock -i "$background_resized" -c '#000000' \
--insidever-color=$B   \
--ringver-color=$V     \
--insidewrong-color=$C \
--ringwrong-color=$W   \
\
--inside-color=$B      \
--ring-color=$C        \
--line-color=$B        \
--separator-color=$C   \
\
--verif-color=$D        \
--wrong-color=$T        \
--time-color=$T        \
--date-color=$T        \
--layout-color=$T      \
--keyhl-color=$D       \
--bshl-color=$T        \
\
--screen 1            \
--clock               \
--indicator           \
--time-str="%H:%M:%S"  \
--date-str="%Y-%m-%d" || i3lock -c '#000000' # Simplified version if i3lock-color is not installed
