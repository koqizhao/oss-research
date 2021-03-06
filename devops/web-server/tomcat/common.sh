#!/bin/bash

source ../common.sh

component=${component:=tomcat}
servers=(${tomcat_servers[@]})

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
