#!/bin/bash
B='#00000000'  # blank
C='#ffffff22'  # clear ish
D='#ffffff66'  # clear ish
T='#ffffffcc'  # clear ish
W='#88000044'  # wrong
V='#ffffff44'  # verifying

#screenarea=$(xrandr --current | grep -oP '(?<=current )\d+ x \d+')
#screenarea=${screenarea// /}
#
#background="$HOME/Pictures/lockscreen.png"
#background_resized="$HOME/Pictures/lockscreen_resized.png"
#
#convert "$background" \
#    -scale "$screenarea^" \
#    -gravity center \
#    -extent "$screenarea" \
#    "$background_resized"

#i3lock -i "$background_resized" -c '#000000' \
i3lock -c '#000000' \
--insidevercolor=$B   \
--ringvercolor=$V     \
\
--insidewrongcolor=$C \
--ringwrongcolor=$W   \
\
--insidecolor=$B      \
--ringcolor=$C        \
--linecolor=$B        \
--separatorcolor=$C   \
\
--verifcolor=$D        \
--wrongcolor=$T        \
--timecolor=$T        \
--datecolor=$T        \
--layoutcolor=$T      \
--keyhlcolor=$D       \
--bshlcolor=$T        \
\
--screen 1            \
--clock               \
--indicator           \
--timestr="%H:%M:%S"  \
--datestr="%Y-%m-%d" \

#rm "$background_resized"
