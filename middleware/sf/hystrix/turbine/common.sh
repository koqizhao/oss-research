#!/bin/bash

source ../common.sh

component=turbine
servers=(${turbine_servers[@]})

export tomcat_version=8
export tomcat_service_port=18080
export tomcat_server_port=`expr $tomcat_service_port - 75`
tomcat_path=~/Research/devops/web-server/tomcat/

export stop_start_interval=10

remote_status()
{
    remote_systemctl $1 status tomcat $PASSWORD
}

remote_start()
{
    remote_enable $1 tomcat $PASSWORD
}

remote_stop()
{
    remote_disable $1 tomcat $PASSWORD
}
