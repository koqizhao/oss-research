#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/logs/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -f ~/shardingsphere-ui-configs.yaml"
}

batch_stop

batch_clean
