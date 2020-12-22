#!/bin/bash

source ../common.sh

component=eladmin-web
servers=(${web_servers[@]})
server_port=$web_server_port

export component
export nginx_server_port=$server_port

remote_status()
{
    remote_systemctl $1 status $component $PASSWORD
}

remote_start()
{
    remote_enable $1 $component $PASSWORD
}

remote_stop()
{
    remote_disable $1 $component $PASSWORD
}
