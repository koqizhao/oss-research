#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    server=$1

    ssh $server "rm -rf $deploy_path/$component"
    ssh $server "rm -rf $deploy_path/data/$component"
    ssh $server "rm -rf $deploy_path/logs/$component"
}

batch_stop

servers=(`merge_array ${name_servers[@]} ${broker_role_server_map[@]}`)
batch_clean
