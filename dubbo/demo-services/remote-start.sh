#!/bin/bash

service_app=dubbo-starter-soul-app
client_app=dubbo-starter-springboot-client
deploy_path=/home/koqizhao/dubbo/demo-services

scale="dist"
if [ -n "$1" ]
then
    scale=$1
fi

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source ./servers-$scale.sh

for server in ${service_servers[@]}
do
    echo  "remote server: $server"
    ssh $server "cd $deploy_path/$service_app; ./start-$service_app.sh"
    ssh $server "ps aux | grep java | grep $service_app"
    echo
done

for server in ${client_servers[@]}
do
    echo  "remote server: $server"
    ssh $server "cd $deploy_path/$client_app; ./start-$client_app.sh"
    ssh $server "ps aux | grep java | grep $client_app"
    echo
done
