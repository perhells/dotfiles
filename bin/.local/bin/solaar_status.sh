#!/usr/bin/env bash

if ! hash solaar; then
    echo ""
    exit 0
fi

SOLAAR_OUTPUT=$(solaar show 2> /dev/null | grep 'Kind\s*:\s*\|Battery\s*:\s*' | sed -e "s/.*:\s*//")
readarray -t SOLAAR_ARRAY <<<"$SOLAAR_OUTPUT"
len=${#SOLAAR_ARRAY[@]}
output=""
for (( i=0; i<$len; i = i + 2 )); do
    unit="${SOLAAR_ARRAY[$i]}"
    if [ "$1" != "$unit" ]; then
        continue
    fi
    data="${SOLAAR_ARRAY[$i+1]}"
    #echo "$unit=$data"
    if [ "$unit" == "mouse" ]; then
        icon=""
    else
        if [ "$unit" == "keyboard" ]; then
            icon=""
        else
            continue
        fi
    fi
    if [[ "$data" == "low"* ]]; then
        level=" "
    else
        if [[ "$data" == "full"* ]]; then
            level=" "
        else
            if [[ "$data" == "N/A"* ]]; then
                level=""
            else
                if [[ "$data" == "unknown (device is offline)"* ]]; then
                    level=" "
                else
                    level=" $data"
                    echo "$data" >> ~/solaar_unknown_status
                    #25% = 
                    #50% = 
                    #75% = 
                fi
            fi
        fi
    fi
    if [[ "$data" == *", discharging." ]]; then
        change=""
    else
        if [[ "$data" == *", recharging." ]]; then
            change=" "
        else
            if [[ "$data" == *", full." ]]; then
                change=" "
            else
                if [[ "$data" == "unknown (device is offline)"* ]]; then
                    change=""
                else
                    change=" unknown: $data"
                fi
            fi
        fi
    fi
    echo "$icon$level$change"
done
