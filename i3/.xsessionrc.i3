#!/usr/bin/env bash

OPTIND=1
DPI=144
while getopts "d:m:" opt; do
    case "$opt" in
    d)  DPI=$OPTARG
        ;;
    m)  MONITOR=$OPTARG
        ;;
    esac
done
shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift

echo "MONITOR=$MONITOR"
echo "DPI=$DPI"

runIfNotRunning () {
  if pgrep $1 > /dev/null; then
    echo "Process \"$1\" is running, skipping!"
  else
    if which $1 2> /dev/null; then
      $@
    else
      echo "Command \"$1\" not found, skipping!"
    fi
  fi
}

killIfRunning () {
  if ! pkill $1; then
    echo "Process \"$1\" not found, skipping!"
  fi
}

LC_NUMERIC="en_US.UTF-8"

echo "Xft.dpi: $DPI" > .Xresources.custom

xrdb -merge .Xresources.custom

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

# Automatically set screen resolution
autoxrandr.sh $MONITOR

# Set background
~/.fehbg

# Dunst
DUNSTRC="$HOME/.config/dunst/dunstrc.$DPI"

DUNST_WIDTH=$(printf "%0.0f" $(bc -l <<< "$DPI * 3.4375"))
DUNST_HEIGHT=$(printf "%0.0f" $(bc -l <<< "$DPI * 0.05208"))
DUNST_OFFSET_X=$(printf "%0.0f" $(bc -l <<< "$DPI * 0.15625"))
DUNST_OFFSET_Y=$(printf "%0.0f" $(bc -l <<< "$DPI * 0.41666"))
DUNST_GEOMETRY="${DUNST_WIDTH}x${DUNST_HEIGHT}-${DUNST_OFFSET_X}+${DUNST_OFFSET_Y}"

sed -e "s/\${DUNST_GEOMETRY}/$DUNST_GEOMETRY/" ~/.config/dunst/dunstrc.custom > "$DUNSTRC"

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
if [ -f ~/.config/picom.conf ]; then
  picom --config ~/.config/picom.conf &
fi

# Dropbox
if pgrep dropbox > /dev/null; then
  echo "Process \"dropbox\" is running, skipping!"
else
  if which dropbox 2> /dev/null; then
    DISPLAY= dropbox start -i &
  else
    echo "Command \"dropbox\" not found, skipping!"
  fi
fi

# Optimus Manager Applet
runIfNotRunning optimus-manager-qt &

# Autoname workspaces
killIfRunning autoname_workspaces.py
~/.config/i3/i3scripts/autoname_workspaces.py --norenumber_workspaces &

# xbindkeys
killIfRunning xbindkeys
xbindkeys

# Check if dotfiles are up to date
dotfiles_check
