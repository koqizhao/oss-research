#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" .

source common.sh

project_path=/home/koqizhao/Projects/misc/soul

remote_deploy()
{
    server=$1
    component=$2
    deploy_file=$project_path/$component/target/$component.jar

    ssh $server "mkdir -p $deploy_path/$component"

    scp $deploy_file $server:$deploy_path/$component
    scp start-$component.sh $server:$deploy_path/$component

    ssh $server "cd $deploy_path/$component; ./start-$component.sh"
}

servers=${admin_servers[@]}
component=$admin_component
batch_deploy

servers=${bootstrap_servers[@]}
component=$bootstrap_component
batch_deploy
