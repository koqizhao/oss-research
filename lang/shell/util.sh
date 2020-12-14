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

uppercase_first()
{
    declare foo=$1
    echo $(tr '[:lower:]' '[:upper:]' <<< ${foo:0:1})${foo:1}
}

is_empty_dir()
{
    if [ -z "$1" ] || [ ! -d "$1" ]; then
        echo -e "\nusage: is_empty_dir <dir>\n" >&2
        echo 0
    fi

    declare c="`ls -A $1`"
    if [ -z "$c" ]; then
        echo 1
    else
        echo 0
    fi
}

clean_empty_folder()
{
    if [ ! -d "$1" ]; then
        return
    fi

    declare content=(`ls -A $1`)
    declare i
    for i in ${content[@]}
    do
        clean_empty_folder $1/$i
    done

    declare is_empty=`is_empty_dir $1`
    if [ "$is_empty" == 1 ]; then
        echo -e "\nrm -rf $1\n" >&2
        rm -rf $1
    fi
}
