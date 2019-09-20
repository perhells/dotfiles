#!/usr/bin/env bash

runIfNotRunning() {
    pgrep $1 > /dev/null 2>&1 || $@
}

synclient HorizScrollDelta=-48
synclient VertScrollDelta=-48
synclient VertEdgeScroll=0
synclient HorizEdgeScroll=0
synclient VertTwoFingerScroll=1
synclient HorizTwoFingerScroll=1
synclient TapButton1=1
synclient TapButton2=3
synclient TapButton3=2
synclient ClickFinger1=1
synclient ClickFinger2=3
synclient ClickFinger3=2

xset r rate 250 50
xset -display :0 s off -dpms

~/.fehbg &
runIfNotRunning compton --config ~/.config/compton.conf &
runIfNotRunning nm-applet &
runIfNotRunning dunst &
