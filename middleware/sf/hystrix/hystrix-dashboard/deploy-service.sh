#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=standalone-hystrix-dashboard-1.5.6-all.jar

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/$component"

    scp ~/Software/hystrix/$deploy_file $server:$deploy_path/$component
    ssh $server "cd $deploy_path/$component; mv $deploy_file $component.jar; "

    scp start.sh $server:$deploy_path/$component
}

batch_deploy

batch_start
