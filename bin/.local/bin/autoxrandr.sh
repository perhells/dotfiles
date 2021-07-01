#!/bin/bash
connected_outputs=$(xrandr | grep '\Wconnected' | sort | awk '{ print $1 }')
connected_count=$(echo $connected_outputs | wc -w)
off_outputs=$(xrandr | grep '\Wdisconnected' | awk '{ print $1 }')

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

# Find internal monitor
internal=""
for output in $connected_outputs; do
    if [[ $output =~ ^LVDS.* ]]; then
        internal=$output
        break
    fi
done
for output in $connected_outputs; do
    if [[ $output =~ ^eDP.* ]]; then
        internal=$output
        break
    fi
done

if (( $connected_count == 1 )); then
    main=${connected_outputs[0]}
    echo "Using $main as single output"
    xrandr --output $main --auto --primary
    for output in $off_outputs; do
        if [[ $output != $main ]]; then
            echo "(disconnected) $output: off"
            xrandr --output $output --off
        fi
    done
else
    if (( $connected_count == 3 )); then
        echo "Mobprog detected, using preset!"
        previous=""
        for output in $connected_outputs; do
            if [[ $output = $internal ]]; then
                echo "$output: off"
                xrandr --output $output --off
            else
                if [[ $previous = "" ]]; then
                    echo "$output: 1920x1080 primary"
                    xrandr --output $output --mode 1920x1080 --primary
                else
                    echo "$output: 1920x1080 right-of $previous"
                    xrandr --output $output --mode 1920x1080 --right-of $previous
                fi
                previous=$output
            fi
        done
        for output in $off_outputs; do
            if [[ $output != $main ]]; then
                echo "(disconnected) $output: off"
                xrandr --output $output --off
            fi
        done
    else
        if [[ $internal != "" ]]; then
            echo "Internal output found"
            echo "$internal: off"
            xrandr --output $internal --off
            previous=""
            for output in $connected_outputs; do
                if [[ $output != $internal ]]; then
                    if [[ $previous = "" ]]; then
                        echo "$output: auto primary"
                        xrandr --output $output --auto --primary
                    else
                        echo "$output: auto right-of $previous"
                        xrandr --output $output --auto --right-of $previous
                    fi
                    previous=$output
                fi
            done
        else
            echo "No internal output found"
            previous=""
            for output in $connected_outputs; do
                if [[ $previous = "" ]]; then
                    echo "$output: auto primary"
                    xrandr --output $output --auto --primary
                else
                    echo "$output: auto right-of $previous"
                    xrandr --output $output --auto --right-of $previous
                fi
                previous=$output
            done
            for output in $off_outputs; do
                if [[ $output != $internal ]]; then
                    echo "(disconnected) $output: off"
                    xrandr --output $output --off
                fi
            done
        fi
    fi
fi
