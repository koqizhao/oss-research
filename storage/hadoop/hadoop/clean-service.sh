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

    ssh $server "echo '$PASSWORD' | sudo -S apt purge -y ssh pdsh;"
    ssh $server "echo '$PASSWORD' | sudo -S apt autoremove --purge -y;"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/pdsh"

    echo
}

batch_clean

for server in ${nfs_gateway_nodes[@]}
do
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $mount_point"

    ssh $server "echo '$PASSWORD' | sudo -S systemctl start rpcbind;"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable rpcbind;"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start rpcbind.socket;"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable rpcbind.socket;"
    ssh $server "echo '$PASSWORD' | sudo -S apt purge -y nfs-common;"
    ssh $server "echo '$PASSWORD' | sudo -S apt autoremove --purge -y"
done
