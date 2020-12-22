#!/bin/bash

source ../common.sh

component=eladmin
servers=(${admin_servers[@]})
server_port=$admin_server_port

remote_status()
{
    remote_ps $1 $component.jar
}

remote_start()
{
    ssh $1 "cd $deploy_path/$component; ./start.sh; "
}

remote_stop()
{
    remote_kill $1 $component.jar
}
