#!/bin/bash

HOSTNAME=$(hostname)

if [ "$HOSTNAME" == "caesium" ]; then
  DPI=144
  bar=4k
else
  DPI=96
  bar=default
fi

if [ "$#" -eq 1 ]; then
  DPI=$1
fi

ETH_INTERFACE=$(ifconfig | grep "^e" | awk -F : '{print $1}')
WLAN_INTERFACE=$(ifconfig | grep "^w" | awk -F : '{print $1}')

let "HEIGHT = $DPI / 4"
let "TRAYSIZE = $DPI / 6"
let "LINESIZE = $DPI / 32"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
if type "xrandr" > /dev/null; then
  for MONITOR in $(xrandr --query | grep "connected\(\s\w\+\)*[0-9]\+x[0-9]\++[0-9]\++[0-9]\+" | sort | cut -d" " -f1); do
    TRAY_POS=""
    if xrandr | grep primary | grep $MONITOR > /dev/null; then
      TRAY_POS="right"
    fi

    echo MONITOR=$MONITOR \
      DPI=$DPI \
      HEIGHT=$HEIGHT \
      TRAYSIZE=$TRAYSIZE \
      LINESIZE=$LINESIZE \
      TRAY_POS=$TRAY_POS \
      ETH_INTERFACE=$ETH_INTERFACE \
      WLAN_INTERFACE=$WLAN_INTERFACE \
      polybar --reload custom &
    MONITOR=$MONITOR \
      DPI=$DPI \
      HEIGHT=$HEIGHT \
      TRAYSIZE=$TRAYSIZE \
      LINESIZE=$LINESIZE \
      TRAY_POS=$TRAY_POS \
      ETH_INTERFACE=$ETH_INTERFACE \
      WLAN_INTERFACE=$WLAN_INTERFACE \
      polybar --reload custom &
  done
else
  polybar --reload $bar &
fi

echo "Polybars launched..."
