#!/bin/bash
outputs=$(xrandr | grep '\Wconnected' | awk '{ print $1 }')
off_outputs=$(xrandr | grep '\Wdisconnected' | awk '{ print $1 }')
outputcount=$(echo "$outputs" | wc -l)

for output in $outputs; do
    if [[ $output =~ ^LVDS.*$ ]] || [[ $output =~ ^eDP.*$ ]]; then
        main=$output
        break
    fi
done

if [ "$outputcount" -gt 1 ]; then
    echo "$main: auto primary"
    xrandr --output $main --primary --auto
    #previous=$main
    for output in $outputs; do
        if [[ ! $output =~ ^LVDS.*$ ]] && [[ ! $output =~ ^eDP.*$ ]]; then
            scale=""
            if [ "$output" = "DP1" ]; then
                scale="--scale 1.5x1.5"
            fi
            echo "xrandr $output: auto (scale: $scale)"
            xrandr --output $output --auto --primary $scale --output $main --off
            #echo "xrandr $output: auto (above $previous) $scale"
            #xrandr --output $output --auto --above $previous $scale
            #previous=$output
        fi
    done
    for output in $off_outputs; do
        echo "$output: off"
        xrandr --output $output --off
    done
    ~/.fehbg
else
    if [ "$main" != "" ]; then
        echo "$main: auto primary"
        xrandr --output $main --auto --primary
        for output in $off_outputs; do
            echo "$output: off"
            xrandr --output $output --off
        done
        ~/.fehbg
    else
        echo "Couldn't find any output starting with \"LVDS\" or eDP!"
        exit 1
    fi
fi
