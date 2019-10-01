#!/bin/bash

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
  TRAY_POS=right
  for MONITOR in $(xrandr --query | grep " connected" | sort | cut -d" " -f1); do
    echo "Starting polybar $bar on $MONITOR"
    MONITOR=$MONITOR TRAY_POS=$TRAY_POS polybar --reload $bar &
    TRAY_POS=""
  done
else
  polybar --reload $bar &
fi

echo "Polybar launched..."
