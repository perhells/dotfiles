#!/bin/bash
outputs=$(xrandr | grep '\Wconnected' | sort | awk '{ print $1 }')
off_outputs=$(xrandr | grep '\Wdisconnected' | awk '{ print $1 }')
outputcount=$(echo "$outputs" | wc -l)

if [ "$#" -eq 1 ]; then
    if [[ $outputs =~ (^|[[:space:]])"$1"($|[[:space:]]) ]]; then
        echo "Using output: $1"
        xrandr --output $1 --auto --scale 1x1 --primary
        for output in $outputs; do
            if [[ ! $output =~ ^$1$ ]]; then
                echo "$output: off"
                xrandr --output $output --off
            fi
        done
        exit 0
    else
        echo "Could not find output $1!"
        exit 1
    fi
fi

for output in $outputs; do
    if [[ $output =~ ^LVDS.*$ ]] || [[ $output =~ ^eDP.*$ ]]; then
        main=$output
        break
    fi
done

if [[ $outputs =~ (^|[[:space:]])"DVI-I-1-1"($|[[:space:]]) ]] && [[ $outputs =~ (^|[[:space:]])"DVI-I-2-2"($|[[:space:]]) ]]; then
    echo "Mobprog detected, using preset!"
    for output in $outputs; do
        if [[ ! $output =~ ^DVI.*$ ]]; then
            echo "$output: off"
            xrandr --output $output --off
        fi
    done

    echo "$output: right"
    xrandr --output "DVI-I-1-1" --auto --primary
    echo "$output: left"
    xrandr --output "DVI-I-2-2" --auto --left-of "DVI-I-1-1"
    exit 0
fi

if [ "$outputcount" -gt 1 ]; then
    echo "$main: off"
    xrandr --output $main --off
    previous=$main
    for output in $outputs; do
        if [[ ! $output =~ ^LVDS.*$ ]] && [[ ! $output =~ ^eDP.*$ ]]; then
            if [ $previous = $main ]; then
                echo "$output: --auto --primary"
                xrandr --output $output --auto --primary
            else
                echo "$output: --auto --left-of $previous"
                xrandr --output $output --auto --left-of $previous
            fi
            previous=$output
        fi
    done
    for output in $off_outputs; do
        echo "$output: off"
        xrandr --output $output --off
    done
else
    if [ "$main" != "" ]; then
        echo "$main: auto primary"
        xrandr --output $main --auto --primary
        for output in $off_outputs; do
            echo "$output: off"
            xrandr --output $output --off
        done
    else
        echo "Couldn't find any output starting with \"LVDS\" or eDP!"
        exit 1
    fi
fi
