#!/bin/bash

if [ -z "$PASSWORD" ]; then
    echo -n "password: "
    read -s PASSWORD
    echo
fi

scale="dist"
if [ -n "$1" ]
then
    scale=$1
fi

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path

source ~/Research/remote-enable.sh
source servers-$scale.sh

for server in ${servers[@]}
do
    echo -e "\nremote server: $server\n"
    enable $server $PASSWORD elasticsearch
done
