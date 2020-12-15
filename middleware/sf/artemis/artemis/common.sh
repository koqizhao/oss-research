#!/bin/bash

source ../common.sh

component=artemis

export component
export tomcat_version=8
export tomcat_service_port=$artemis_port
export tomcat_server_port=`expr $artemis_port - 75`

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
