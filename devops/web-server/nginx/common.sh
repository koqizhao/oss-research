#!/bin/bash

source ../common.sh

component=${component:=nginx}
servers=(${nginx_servers[@]})

remote_status()
{
    remote_systemctl $1 status $2 $PASSWORD
}

remote_start()
{
    remote_enable $1 $2 $PASSWORD
}

remote_stop()
{
    remote_disable $1 $2 $PASSWORD
}
