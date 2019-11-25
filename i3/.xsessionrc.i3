#!/usr/bin/env bash


runIfNotRunning() {
    pgrep -f $1 > /dev/null 2>&1 || $@
}

if [ "$#" -eq 1 ]; then
  DPI=$1
else
  if [ "$HOSTNAME" == "caesium" ]; then
    DPI=144
  else
    DPI=96
  fi
fi

LC_NUMERIC="en_US.UTF-8"

DUNST_WIDTH=$(printf "%0.0f" $(bc -l <<< "$DPI * 3.4375"))
DUNST_HEIGHT=$(printf "%0.0f" $(bc -l <<< "$DPI * 0.05208"))
DUNST_OFFSET_X=$(printf "%0.0f" $(bc -l <<< "$DPI * 0.15625"))
DUNST_OFFSET_Y=$(printf "%0.0f" $(bc -l <<< "$DPI * 0.41666"))

DUNST_GEOMETRY="${DUNST_WIDTH}x${DUNST_HEIGHT}-${DUNST_OFFSET_X}+${DUNST_OFFSET_Y}"

echo "Xft.dpi: $DPI" > .Xresources.custom

xrdb -merge .Xresources.custom

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

# Compton must be restarted later, after running xrandr
pkill compton

autoxrandr.sh
~/.fehbg
~/.config/polybar/launch.sh $DPI &

DUNSTRC="$HOME/.config/dunst/dunstrc.$DPI"
sed -e "s/\${DUNST_GEOMETRY}/$DUNST_GEOMETRY/" ~/.config/dunst/dunstrc > "$DUNSTRC"
pkill dunst
dunst -config "$DUNSTRC" &

runIfNotRunning nm-applet &
runIfNotRunning ~/.config/i3/i3scripts/autoname_workspaces.py --norenumber_workspaces &

# Restart compton
compton --config ~/.config/compton.conf &
