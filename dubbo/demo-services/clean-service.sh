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

for server in ${client_servers[@]}
do
    echo -e "clean started: $server\n"
    ssh $server "pid=\`ps aux | grep java | grep $client_app | awk '{ print \$2 }'\`; kill \$pid;"
    ssh $server "rm -rf $deploy_path/$client_app;"
    echo -e "clean finished: $server\n"
done

for server in ${service_servers[@]}
do
    echo -e "clean started: $server\n"
    ssh $server "pid=\`ps aux | grep java | grep $service_app | awk '{ print \$2 }'\`; kill \$pid;"
    ssh $server "rm -rf $deploy_path/$service_app;"
    echo -e "clean finished: $server\n"
done
