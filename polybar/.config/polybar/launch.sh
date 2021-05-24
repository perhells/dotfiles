#!/bin/bash

if [ "$#" -eq 1 ]; then
  DPI=$1
else
  DPI=144
fi

ETH_INTERFACE=$(ifconfig | grep "^e" | awk -F : '{print $1}')
WLAN_INTERFACE=$(ifconfig | grep "^w" | awk -F : '{print $1}')

let "HEIGHT = $DPI / 4"
let "TRAYSIZE = $DPI / 6"
let "LINESIZE = $DPI / 32"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done

for thermal_zone_x in $(find /sys/class/thermal/ -name "thermal_zone*"); do
  if [[ $(cat $thermal_zone_x/type) = x86_pkg_temp ]]; then
    THERMAL_ZONE=$(echo "$thermal_zone_x" | sed 's/[^0-9]*//g')
  fi
done

echo "Thermal zone: $THERMAL_ZONE"

# Launch Polybar, using default config location ~/.config/polybar/config
if type "xrandr" > /dev/null; then
  for MONITOR in $(xrandr --query | grep "\sconnected\(\s\w\+\)*[0-9]\+x[0-9]\++[0-9]\++[0-9]\+" | sort | cut -d" " -f1); do
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
      THERMAL_ZONE=$THERMAL_ZONE \
      polybar --reload &
    MONITOR=$MONITOR \
      DPI=$DPI \
      HEIGHT=$HEIGHT \
      TRAYSIZE=$TRAYSIZE \
      LINESIZE=$LINESIZE \
      TRAY_POS=$TRAY_POS \
      ETH_INTERFACE=$ETH_INTERFACE \
      WLAN_INTERFACE=$WLAN_INTERFACE \
      THERMAL_ZONE=$THERMAL_ZONE \
      polybar --reload default &
  done
else
  polybar --reload default &
fi

echo "Polybars launched..."
