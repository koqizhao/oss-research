#!/bin/bash

source ../common.sh

component=cat

export tomcat_service_port=8080
export tomcat_server_port=`expr $tomcat_service_port - 75`
tomcat_path=~/Research/devops/web-server/tomcat/

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
