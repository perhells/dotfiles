#!/bin/bash

if [ "$#" -eq 1 ]; then
  DPI=$1
else
  if [ "$HOSTNAME" == "caesium" ]; then
    DPI=144
  else
    DPI=96
  fi
fi

let "HEIGHT = $DPI / 4"
let "TRAYSIZE = $DPI / 6"
let "LINESIZE = $DPI / 32"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
HOSTNAME=$(hostname)
if [ "$HOSTNAME" == "caesium" ]; then
  bar=4k
else
  bar=default
fi

if type "xrandr" > /dev/null; then
  for MONITOR in $(xrandr --query | grep " connected" | sort | cut -d" " -f1); do
    TRAY_POS=""
    if xrandr | grep primary | grep $MONITOR > /dev/null; then
      TRAY_POS="right"
    fi

    echo "MONITOR=$MONITOR DPI=$DPI TRAY_POS=$TRAY_POS polybar --reload custom &"
    MONITOR=$MONITOR \
      DPI=$DPI \
      HEIGHT=$HEIGHT \
      TRAYSIZE=$TRAYSIZE \
      LINESIZE=$LINESIZE \
      TRAY_POS=$TRAY_POS \
      polybar --reload custom &
  done
else
  polybar --reload $bar &
fi

echo "Polybars launched..."
