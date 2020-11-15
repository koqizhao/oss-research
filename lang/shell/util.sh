#!/bin/bash

escape_slash()
{
    declare tmp
    tmp=$(sed 's/\\/\\\\/g' <<< "$1")
    sed 's/\//\\\//g' <<< "$tmp"
}

merge_array()
{
    declare -A all
    for i in $@
    do
        all[$i]=$i
    done
    echo ${!all[@]}
}
