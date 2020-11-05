#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

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
    echo "remote server: $server"
    enable $server $PASSWORD zookeeper
done
