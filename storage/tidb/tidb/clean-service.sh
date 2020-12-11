#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    if [ $scale == "dist" ]; then
        ssh $server "cd $deploy_path/$component; tiup cluster destroy -y lab;"
        ssh $server "echo '$PASSWORD' | sudo -S userdel -rf tidb"
        ssh $server "echo '$PASSWORD' | sudo -S rm -rf /root/.ssh"
    fi

    ssh $1 "tiup clean --all"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/.tiup"

    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/data/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/logs/$component"
}

batch_stop

batch_clean
