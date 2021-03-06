#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop $component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl disable $component.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -f /etc/systemd/system/$component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/data/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/logs/$component"
}

batch_clean
