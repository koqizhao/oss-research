#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path

source ~/Research/remote-enable.sh
source servers.sh

for server in ${servers[@]}
do
    echo "remote server: $server"
    enable $server $PASSWORD kibana
done
