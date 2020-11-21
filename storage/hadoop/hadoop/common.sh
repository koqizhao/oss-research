#!/bin/bash

source ../common.sh

component=hadoop
mount_point=$deploy_path/s_hdfs

remote_status()
{
    remote_ps $1 $2
}

start_hdfs_share()
{
    ssh $hdfs_share_server "echo '$PASSWORD' | sudo -S $deploy_path/$component/bin/hdfs --daemon start portmap"
    sleep 5
    ssh $hsdf_share_server "$deploy_path/$component/bin/hdfs --daemon start nfs3"
    sleep 5
    ssh $hdfs_share_server "echo '$PASSWORD' | sudo -S mount -t nfs -o vers=3,proto=tcp,nolock,noacl,sync $hdfs_share_server:/ $mount_point"
}

stop_hdfs_share()
{
    ssh $hdfs_share_server "echo '$PASSWORD' | sudo -S umount $mount_point"
    ssh $hdfs_share_server "$hadoop_home/bin/hdfs --daemon stop nfs3"
    ssh $hdfs_share_server "echo '$PASSWORD' | sudo -S $deploy_path/$component/bin/hdfs --daemon stop portmap"
}
