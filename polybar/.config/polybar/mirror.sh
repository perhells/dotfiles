#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if type "xrandr" > /dev/null; then
  for MONITOR in $(xrandr --query | grep " connected" | sort | cut -d" " -f1); do
    echo "Starting polybar $bar on $MONITOR"
    MONITOR=$MONITOR TRAY_POS=right polybar --reload mirror &
  done
else
  polybar --reload mirror &
fi

echo "Polybar launched..."
