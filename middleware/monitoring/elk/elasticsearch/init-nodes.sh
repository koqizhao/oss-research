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
source servers-$scale.sh

for server in ${servers[@]}
do
    echo "remote server: $server"
    scp init-env.sh $server:./
    ssh $server "echo '$PASSWORD' | sudo -S sh init-env.sh; rm init-env.sh; echo '$PASSWORD' | sudo -S reboot"
    echo
done
