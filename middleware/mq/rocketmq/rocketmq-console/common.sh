#!/bin/bash

source ../common.sh

component=rocketmq-console
servers=(${console_servers[@]})

remote_start()
{
    ssh $1 "cd $deploy_path/$component; ./start.sh; "
}

remote_stop()
{
    remote_kill $1 $component
}

remote_status()
{
    remote_ps $1 $component
}
