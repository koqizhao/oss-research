#!/bin/bash

if [ -z "$PASSWORD" ]; then
    echo -n "password: "
    read -s PASSWORD
    echo
fi

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path

source ~/Research/remote-enable.sh
source servers.sh

for server in ${servers[@]}
do
    echo -e "\nremote server: $server\n"
    disable $server $PASSWORD filebeat
done
