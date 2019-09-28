#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

server=192.168.56.11
action=start
if [ -n "$1" ]
then
    action=$1
fi

hadoop_home=/home/koqizhao/hadoop/hadoop
mount_point=/home/koqizhao/hadoop/s_hdfs

case $action in
    start)
        ssh $server "echo '$PASSWORD' | sudo -S $hadoop_home/bin/hdfs --daemon $action portmap"
        sleep 5
        ssh $server "$hadoop_home/bin/hdfs --daemon $action nfs3"
        sleep 5
        ssh $server "echo '$PASSWORD' | sudo -S mount -t nfs -o vers=3,proto=tcp,nolock,noacl,sync $server:/ $mount_point"

        ;;
    stop)
        ssh $server "echo '$PASSWORD' | sudo -S umount $mount_point"
        ssh $server "$hadoop_home/bin/hdfs --daemon $action nfs3"
        ssh $server "echo '$PASSWORD' | sudo -S $hadoop_home/bin/hdfs --daemon $action portmap"

        ;;
    *)
        echo "not supported action: $action"
        ;;
esac

echo
