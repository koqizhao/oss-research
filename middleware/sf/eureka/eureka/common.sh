#!/bin/bash

source ../common.sh

component=eureka

export tomcat_version=8
export tomcat_service_port=$eureka_port
export tomcat_server_port=`expr $eureka_port - 75`
tomcat_path=~/Research/devops/web-server/tomcat/

eureka_service_url=""
for s in ${servers[@]}
do
    if [ -z "$eureka_service_url" ]; then
        eureka_service_url="http://$s:$eureka_port/eureka/v2"
    else
        eureka_service_url="$eureka_service_url,http://$s:$eureka_port/eureka/v2"
    fi
done

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
