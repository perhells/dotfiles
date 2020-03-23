#!/bin/bash

runIfNotRunning() {
    pgrep $1 > /dev/null 2>&1 || $@
}

if hash synclient 2> /dev/null; then
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
fi

# Faster keyboard repeat rate
xset r rate 250 50
# Remove mouse acceleration
xset m 0 0

MOUSE_SPEED_REDUCTION=3
if xinput list | grep "Mionix NAOS 8200" > /dev/null; then
    # Reduce mouse speed if Mionix NAOS 8200 exists
    MOUSE_ID=$(xinput list | grep "Mionix NAOS 8200.*pointer" | sed -e "s/.*id=\([0-9]\+\).*/\1/")
    PROP_ID=$(xinput list-props $MOUSE_ID | grep "Coordinate Transformation Matrix" | sed -e "s/.*(\([0-9]\+\)):.*/\1/")
    xinput set-prop "$MOUSE_ID" "$PROP_ID" 1 0 0 0 1 0 0 0 "$MOUSE_SPEED_REDUCTION"
fi

# Disable sleep
xset -display :0 s off -dpms

autoxrandr.sh DVI-I-1
~/.fehbg
runIfNotRunning dunst &
runIfNotRunning ~/.config/polybar/launch.sh &
runIfNotRunning picom --config ~/.config/picom.conf &
runIfNotRunning nm-applet &

kill $(pgrep -f autoname_workspaces)
~/.config/i3/i3scripts/autoname_workspaces.py --norenumber_workspaces &
