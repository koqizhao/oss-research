#!/bin/bash

source ../common.sh

component=eladmin-web
servers=(${web_servers[@]})
server_port=$web_server_port

remote_status()
{
    remote_ps $1 $component
}

remote_start()
{
    ssh $1 "cd $deploy_path/$component; ./start.sh; "
}

remote_stop()
{
    remote_kill $1 $component
}
