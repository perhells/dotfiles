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

if type "xrandr"; then
  for MONITOR in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$MONITOR polybar --reload $bar &
  done
else
  polybar --reload $bar &
fi

echo "Polybar launched..."
