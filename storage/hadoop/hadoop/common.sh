#!/bin/bash

source ../common.sh

component=hadoop
mount_point=$deploy_path/s_hdfs

remote_status()
{
    remote_ps $1 $2
}

start_nfs_gateway()
{
    ssh $nfs_gateway_node "echo '$PASSWORD' | sudo -S $deploy_path/$component/bin/hdfs --daemon start portmap"
    sleep 5
    ssh $nfs_gateway_node "$deploy_path/$component/bin/hdfs --daemon start nfs3"
    sleep 5
    ssh $nfs_gateway_node "mkdir -p $mount_point"
    ssh $nfs_gateway_node "echo '$PASSWORD' | sudo -S mount -t nfs -o vers=3,proto=tcp,nolock,noacl,sync $nfs_gateway_node:/share $mount_point"
}

stop_nfs_gateway()
{
    ssh $nfs_gateway_node "echo '$PASSWORD' | sudo -S umount -f -l $mount_point"
    ssh $nfs_gateway_node "$deploy_path/$component/bin/hdfs --daemon stop nfs3"
    ssh $nfs_gateway_node "echo '$PASSWORD' | sudo -S $deploy_path/$component/bin/hdfs --daemon stop portmap"
}
