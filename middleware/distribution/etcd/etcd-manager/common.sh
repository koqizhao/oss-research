#!/bin/bash

source ../common.sh

component=etcd-manager
servers=(${manager_servers[@]})

remote_status()
{
    ps aux | grep $component
}

remote_start()
{
    etcd-manager > /dev/null 2>&1 &
}

remote_stop()
{
    pid=`ps aux | grep "etcd-manager --no-sandbox" | awk '{ print $2 }'`
    if [ -z "$pid" ]; then
        return 0
    fi

    for i in $pid
    do
        kill $i > /dev/null 2>&1
    done
}
