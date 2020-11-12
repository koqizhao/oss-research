#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..

source common.sh

project_path=/home/koqizhao/Projects/koqizhao/java-projects/dubbo-study

remote_deploy()
{
    server=$1
    component=$2
    deploy_file=$project_path/$component/target/io.study.$component-0.0.1.jar

    ssh $server "mkdir -p $deploy_path/$component"

    scp $deploy_file $server:$deploy_path/$component
    scp start-$component.sh $server:$deploy_path/$component

    ssh $server "cd $deploy_path/$component; ./start-$component.sh"
}

servers=${service_servers[@]}
component=$service_component
batch_deploy

servers=${client_servers[@]}
component=$client_component
batch_deploy
