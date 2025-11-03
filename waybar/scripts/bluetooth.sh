#!/usr/bin/env bash

# Check if Bluetooth is powered on
powered=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

if [ "$powered" != "yes" ]; then
    # Bluetooth adapter off
    echo "Off 󰂲"
    exit 0
fi

# Check if any device is connected
connected=$(bluetoothctl info | grep "Connected: yes")
if [ -z "$connected" ]; then
    # Adapter is on but nothing connected
    echo "On "
    exit 0
fi

output=""
devices=$(bluetoothctl devices | awk '{print $2}')

get_battery_icon() {
    local level=$1
    level=${level%%%}  # remove trailing %
    if [ "$level" -ge 90 ]; then
        echo "󰂂"  # Full
    elif [ "$level" -ge 70 ]; then
        echo "󰂀"
    elif [ "$level" -ge 50 ]; then
        echo "󰁾"
    elif [ "$level" -ge 30 ]; then
        echo "󰁼"
    else
        echo "󰁺"  # Low
    fi
}

for dev in $devices; do
    state=$(bluetoothctl info "$dev" | grep "Connected" | awk '{print $2}')
    if [ "$state" = "yes" ]; then
        name=$(bluetoothctl info "$dev" | grep "Name" | awk -F "Name: " '{print $2}')
        battery=$(bluetoothctl info "$dev" | grep -i "Battery Percentage" | sed -E 's/.*\(([^)]*)\).*/\1%/')
        if [ -n "$battery" ]; then
            icon=$(get_battery_icon "$battery")
            output+="$name $icon$battery "
        else
            output+="$name "
        fi
    fi
done


echo "$output"

