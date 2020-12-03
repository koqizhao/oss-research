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
    for server in ${nfs_gateway_nodes[@]}
    do
        ssh $server "echo '$PASSWORD' | sudo -S $deploy_path/$component/bin/hdfs --daemon start portmap"
        sleep 5
        ssh $server "$deploy_path/$component/bin/hdfs --daemon start nfs3"
        sleep 5
        ssh $server "mkdir -p $mount_point"
        ssh $server "echo '$PASSWORD' | \
            sudo -S mount -t nfs -o vers=3,proto=tcp,nolock,noacl,sync $server:/share $mount_point"
    done
}

stop_nfs_gateway()
{
    for server in ${nfs_gateway_nodes[@]}
    do
        ssh $server "echo '$PASSWORD' | sudo -S umount -f -l $mount_point"
        ssh $server "$deploy_path/$component/bin/hdfs --daemon stop nfs3"
        ssh $server "echo '$PASSWORD' | sudo -S $deploy_path/$component/bin/hdfs --daemon stop portmap"
    done
}
