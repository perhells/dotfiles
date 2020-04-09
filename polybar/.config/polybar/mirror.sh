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

if type "xrandr" > /dev/null; then
  for MONITOR in $(xrandr --query | grep " connected" | sort | cut -d" " -f1); do
    TRAY_POS=""
    if xrandr | grep primary | grep $MONITOR > /dev/null; then
      TRAY_POS="right"
    fi

    echo "MONITOR=$MONITOR DPI=$DPI TRAY_POS=$TRAY_POS polybar --reload mirror &"
    MONITOR=$MONITOR \
      DPI=$DPI \
      HEIGHT=$HEIGHT \
      TRAYSIZE=$TRAYSIZE \
      LINESIZE=$LINESIZE \
      TRAY_POS=$TRAY_POS \
      polybar --reload mirror &
  done
else
  echo "Failed to run xrandr..."
  echo 1
fi

echo "Polybars launched..."
