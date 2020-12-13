#!/bin/bash

source ../common.sh

component=hystrix-dashboard
servers=(${dashboard_servers[@]})

remote_status()
{
    remote_ps $1 $2
}

remote_start()
{
    ssh $1 "cd $deploy_path/$component; ./start.sh"
}

remote_stop()
{
    remote_kill $1 $2
}
