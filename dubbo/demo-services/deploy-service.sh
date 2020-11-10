#!/bin/bash

project_path=/home/koqizhao/Projects/koqizhao/java-projects/dubbo-study
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

deploy()
{
    server=$1
    component=$2
    deploy_file=$project_path/$component/target/io.study.$component-0.0.1.jar

    echo -e "\ndeploy started: $server/$component\n"

    ssh $server "mkdir -p $deploy_path/$component"

    scp $deploy_file $server:$deploy_path/$component
    scp start-$component.sh $server:$deploy_path/$component

    ssh $server "cd $deploy_path/$component; ./start-$component.sh"

    echo -e "\ndeploy finished: $server/$component"
}

echo -e "\nservice\n"
for server in ${service_servers[@]}
do
    deploy $server $service_app
done

echo -e "\nclient\n"
for server in ${client_servers[@]}
do
    deploy $server $client_app
done
