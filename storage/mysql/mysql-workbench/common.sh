#!/bin/bash

source ../common.sh

component=mysql-workbench
servers=(${workbench_servers[@]})

remote_status()
{
    ps aux | grep $component
}

remote_start()
{
    mysql-workbench > /dev/null 2>&1 &
}

remote_stop()
{
    pid=`ps aux | grep "/usr/bin/mysql-workbench" | awk '{ print $2 }'`
    if [ -z "$pid" ]; then
        return 0
    fi

    for i in $pid
    do
        kill $i > /dev/null 2>&1
    done
}
