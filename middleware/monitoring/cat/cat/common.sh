#!/bin/bash

source ../common.sh

component=cat

export component
export tomcat_version=8
export tomcat_service_port=8080
export tomcat_server_port=`expr $tomcat_service_port - 75`

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
