#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

stop_nfs_gateway
ssh $name_node "$deploy_path/$component/sbin/stop-dfs.sh"

remote_clean()
{
    server=$1
    ssh $server "echo '$PASSWORD' | sudo -S rm -f /etc/profile.d/hadoop.sh"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/logs/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/name"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/data"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/tmp"
    echo
}

batch_clean

ssh $nfs_gateway_node "echo '$PASSWORD' | sudo -S apt purge -y nfs-common;"
ssh $nfs_gateway_node "echo '$PASSWORD' | sudo -S apt update;"
ssh $nfs_gateway_node "echo '$PASSWORD' | sudo -S apt autoremove --purge -y;"
