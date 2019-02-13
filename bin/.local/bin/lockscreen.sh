#!/bin/bash
B='#00000000'  # blank
C='#ffffff22'  # clear ish
D='#ffffff22'  # clear ish
T='#ffffffcc'  # clear ish
W='#880000bb'  # wrong
V='#ffffff55'  # verifying

i3lock -i '/home/per/Pictures/lockscreen.png' -c '#000000' \
--insidevercolor=$C   \
--ringvercolor=$V     \
\
--insidewrongcolor=$C \
--ringwrongcolor=$W   \
\
--insidecolor=$B      \
--ringcolor=$D        \
--linecolor=$B        \
--separatorcolor=$D   \
\
--verifcolor=$T        \
--wrongcolor=$T        \
--timecolor=$T        \
--datecolor=$T        \
--layoutcolor=$T      \
--keyhlcolor=$T       \
--bshlcolor=$T        \
\
--screen 1            \
--clock               \
--indicator           \
--timestr="%H:%M:%S"  \
--datestr="%Y-%m-%d" \
