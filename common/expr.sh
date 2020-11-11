#!/bin/bash

escape_slash()
{
    echo "$1" > t_tmp
    sed 's/\\/\\\\/g' t_tmp > t_tmp2
    sed 's/\//\\\//g' t_tmp2
    rm t_tmp*
}
