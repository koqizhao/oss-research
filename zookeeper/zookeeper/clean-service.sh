#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..

source common.sh

clean()
{
    server=$1
    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop zookeeper.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl disable zookeeper.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/data"
    ssh $server "echo '$PASSWORD' | sudo -S rm -f /etc/systemd/system/zookeeper.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
}

remote_clean
