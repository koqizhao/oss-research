#!/bin/bash

export char_nl="NEW_LINE"

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

escape_newline()
{
    sed ':a;N;$!ba;s/\r\n/NEW_LINE/g' $1 \
        | sed ':a;N;$!ba;s/\r/NEW_LINE/g' \
        | sed ':a;N;$!ba;s/\n/NEW_LINE/g'
}

restore_newline()
{
    sed 's/NEW_LINE/\n/g' $1
}
