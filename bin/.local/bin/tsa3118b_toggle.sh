#! /usr/bin/env bash

set -e
set -o pipefail

device="FC:A8:9A:A2:BD:B7"

if bluetoothctl info "$device" | grep "Connected: yes" > /dev/null; then
    state="connected"
else
    state="disconnected"
fi

if [ "$state" == "connected" ]; then
    operation="disconnect"
else
    operation="connect"
fi

bluetoothctl $operation $device
