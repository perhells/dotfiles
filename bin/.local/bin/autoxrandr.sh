#!/bin/bash
connected_outputs=$(xrandr | grep '\Wconnected' | sort | awk '{ print $1 }')
off_outputs=$(xrandr | grep '\Wdisconnected' | awk '{ print $1 }')
outputcount=$(echo "$connected_outputs" | wc -l)

# Specific output
if [ "$#" -eq 1 ]; then
    if [[ $connected_outputs =~ (^|[[:space:]])"$1"($|[[:space:]]) ]]; then
        echo "Using output: $1"
        xrandr --output $1 --auto --scale 1x1 --primary
        for output in $connected_outputs; do
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

# Mobprog
if [[ $connected_outputs =~ (^|[[:space:]])"DVI-I-1-1"($|[[:space:]]) ]] && [[ $connected_outputs =~ (^|[[:space:]])"DVI-I-2-2"($|[[:space:]]) ]]; then
    echo "Mobprog detected, using preset!"
    for output in $connected_outputs; do
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

# Prioritization
main=""
for output in $connected_outputs; do
    if [[ $output =~ ^LVDS.* ]]; then
        main=$output
        break
    fi
done
for output in $connected_outputs; do
    if [[ $output =~ ^eDP.* ]]; then
        main=$output
        break
    fi
done
for output in $connected_outputs; do
    if [[ $output = "DP-1" ]]; then
        main=$output
        break
    fi
done
for output in $connected_outputs; do
    if [[ $output = "DP1" ]]; then
        main=$output
        break
    fi
done
for output in $connected_outputs; do
    if [[ $output = "DP2" ]]; then
        main=$output
        break
    fi
done
for output in $connected_outputs; do
    if [[ $output = "DP3" ]]; then
        main=$output
        break
    fi
done

if [[ $main != "" ]]; then
    echo "Main output found: $main"
    xrandr --output $main --auto --scale 1x1 --primary
    for output in $connected_outputs; do
        if [[ ! $output =~ ^$main$ ]]; then
            echo "$output: off"
            xrandr --output $output --off
        fi
    done
    exit 0
else
    echo "No main output found, using all possible monitors"
    previous=$main
    for output in $connected_outputs; do
        if [[ $previous = "" ]]; then
            echo "$output: --auto --primary"
            xrandr --output $output --auto --primary
        else
            echo "$output: --auto --right-of $previous"
            xrandr --output $output --auto --right-of $previous
        fi
        previous=$output
    done
fi
