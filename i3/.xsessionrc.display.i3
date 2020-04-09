#!/bin/bash

killIfRunning () {
  if pgrep $1; then
    killall -q $1
  else
    echo "$1 is currently not running, skipping!"
  fi
}

if [ "$HOSTNAME" == "caesium" ]; then
  DPI=144
else
  DPI=96
fi

set -e

MONITOR=$1

autoxrandr.sh $MONITOR

LC_NUMERIC="en_US.UTF-8"

echo "Xft.dpi: $DPI" > .Xresources.custom

xrdb -merge .Xresources.custom

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

# Picom must be restarted later, after running xrandr
killIfRunning picom

# Set background
~/.fehbg

# Dunst
DUNSTRC="$HOME/.config/dunst/dunstrc.$DPI"

DUNST_WIDTH=$(printf "%0.0f" $(bc -l <<< "$DPI * 3.4375"))
DUNST_HEIGHT=$(printf "%0.0f" $(bc -l <<< "$DPI * 0.05208"))
DUNST_OFFSET_X=$(printf "%0.0f" $(bc -l <<< "$DPI * 0.15625"))
DUNST_OFFSET_Y=$(printf "%0.0f" $(bc -l <<< "$DPI * 0.41666"))
DUNST_GEOMETRY="${DUNST_WIDTH}x${DUNST_HEIGHT}-${DUNST_OFFSET_X}+${DUNST_OFFSET_Y}"

sed -e "s/\${DUNST_GEOMETRY}/$DUNST_GEOMETRY/" ~/.config/dunst/dunstrc > "$DUNSTRC"

killIfRunning dunst
dunst -config "$DUNSTRC" &

# Polybar
~/.config/polybar/launch.sh $DPI &

# Network Manager Applet
killIfRunning nm-applet
nm-applet &

# Alttab
ALTTAB_TILE_WIDTH=$(printf "%0.0f" $(bc -l <<< "$DPI * 1.3"))
ALTTAB_TILE_HEIGHT=$(printf "%0.0f" $(bc -l <<< "$DPI * 1.5"))
ALTTAB_ICON_WIDTH=$(printf "%0.0f" $(bc -l <<< "$DPI * 1.3 - 1"))
ALTTAB_ICON_HEIGHT=$(printf "%0.0f" $(bc -l <<< "$DPI * 0.75"))

ALTTAB_TILE_GEOMETRY="${ALTTAB_TILE_WIDTH}x${ALTTAB_TILE_HEIGHT}"
ALTTAB_ICON_GEOMETRY="${ALTTAB_ICON_WIDTH}x${ALTTAB_ICON_HEIGHT}"

killIfRunning alttab
alttab -fg "#DFDFDF" -bg "#222222" -frame "#0A84FF" -t "$ALTTAB_TILE_GEOMETRY" -i "$ALTTAB_ICON_GEOMETRY" -d 1 &

# Picom
picom --config ~/.config/picom.conf &

# Autoname workspaces
kill $(pgrep -f autoname_workspaces.py) || true
~/.config/i3/i3scripts/autoname_workspaces.py --norenumber_workspaces &
