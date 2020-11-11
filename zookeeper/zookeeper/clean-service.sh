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

clean()
{
    echo -e "\nclean started: $1\n"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl stop zookeeper.service"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl disable zookeeper.service"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf ~/zookeeper/zookeeper"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf ~/zookeeper/data"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -f /etc/systemd/system/zookeeper.service"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    echo -e "\nclean finished: $1"
}

for server in ${servers[@]}
do
    clean $server
done

echo
