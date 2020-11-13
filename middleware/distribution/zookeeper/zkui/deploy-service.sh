#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

project_path=~/Projects/misc/zkui

remote_deploy()
{
    server=$server
    ssh $server "rm -rf $deploy_path/$component"
    ssh $server "mkdir -p $deploy_path/$component"

    scp $project_path/target/zkui-2.0-SNAPSHOT-jar-with-dependencies.jar $server:$deploy_path/$component
    scp config.cfg.$scale $server:$deploy_path/$component/config.cfg
    scp zkui.sh $server:$deploy_path/$component
    ssh $server "cd $deploy_path/$component; ./zkui.sh start"
}

batch_deploy
