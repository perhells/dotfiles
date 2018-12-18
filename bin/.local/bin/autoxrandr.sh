#!/bin/bash
outputs=$(xrandr | grep '\Wconnected' | awk '{ print $1 }')
outputcount=$(echo "$outputs" | wc -l)
echo "$outputs"
echo "$outputcount"

for output in $outputs; do
    if [[ $output =~ ^LVDS.*$ ]]; then
        lvds=$output
    fi
done

if [ "$outputcount" -gt 1 ]; then
    for output in $outputs; do
        if [[ ! $output =~ ^LVDS.*$ ]]; then
            echo xrandr --output $lvds --off --output $output --auto --primary
            xrandr --output $lvds --off --output $output --auto --primary
            exit 0
        fi
    done
else
    if [ "$lvds" != "" ]; then
        echo xrandr --output $lvds --auto --primary
        xrandr --output $lvds --auto --primary
        exit 0
    else
        echo "Couldn't find any output starting with \"LVDS\"!"
        exit 1
    fi
fi
