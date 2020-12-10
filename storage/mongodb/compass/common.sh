#!/bin/bash

source ../common.sh

component=compass
servers=(${compass_servers[@]})

remote_status()
{
    ps aux | grep $component
}

remote_start()
{
    mongodb-compass > /dev/null 2>&1 &
}

remote_stop()
{
    pid=`ps aux | grep "/usr/lib/mongodb-compass" | awk '{ print $2 }'`
    if [ -z "$pid" ]; then
        return 0
    fi

    for i in $pid
    do
        kill $i > /dev/null 2>&1
    done
}
