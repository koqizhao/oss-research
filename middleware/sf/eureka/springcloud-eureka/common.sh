#!/bin/bash

source ../common.sh

component=springcloud-eureka

eureka_service_url=""
for s in ${servers[@]}
do
    if [ -z "$eureka_service_url" ]; then
        eureka_service_url="http://$s:$eureka_port/eureka"
    else
        eureka_service_url="$eureka_service_url,http://$s:$eureka_port/eureka"
    fi
done

remote_status()
{
    remote_ps $1 eureka
}

remote_start()
{
    ssh $1 "cd $deploy_path/$component; ./start.sh; "
}

remote_stop()
{
    remote_kill $1 eureka
}
