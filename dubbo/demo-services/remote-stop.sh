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

echo -e "\nclient\n"
for server in ${client_servers[@]}
do
    echo -e "\nremote server: $server\n"
    ssh $server "pid=\`ps aux | grep java | grep $client_app | awk '{ print \$2 }'\`; kill \$pid;"
    ssh $server "ps aux | grep java | grep $client_app"
    echo
done

echo -e "\nservice\n"
for server in ${service_servers[@]}
do
    echo -e "\nremote server: $server\n"
    ssh $server "pid=\`ps aux | grep java | grep $service_app | awk '{ print \$2 }'\`; kill \$pid;"
    ssh $server "ps aux | grep java | grep $service_app"
    echo
done
