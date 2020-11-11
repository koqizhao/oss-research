#!/bin/bash

init_scale()
{
    scale="basic"
    t_scale_dir=`pwd`
    if [ "$1" == "dist" ]; then
        scale="dist"
    fi

    if [ -n $2 ]; then
        t_scale_dir=$2
    fi

    t_dir_pwd=`pwd`
    cd $t_scale_dir
    source servers-$scale.sh
    cd $t_dir_pwd

    t_scale_dir=""
    t_dir_pwd=""
}
