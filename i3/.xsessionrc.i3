#!/usr/bin/env bash
synclient HorizScrollDelta=-48
synclient VertScrollDelta=-48
synclient VertEdgeScroll=0
synclient HorizEdgeScroll=0
synclient VertTwoFingerScroll=1
synclient HorizTwoFingerScroll=1

xset r rate 250 50

~/.fehbg &
compton &
numlockx &
nm-applet &
