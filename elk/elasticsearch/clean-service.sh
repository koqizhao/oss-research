#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    server=$1
    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop elasticsearch.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl disable elasticsearch.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -f /etc/systemd/system/elasticsearch.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/data/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/logs/$component"
}

batch_clean
