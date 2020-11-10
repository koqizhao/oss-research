#!/bin/bash

deploy_path=/home/koqizhao/zookeeper/zkui

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source ./servers.sh

for server in ${servers[@]}
do
    echo -e "\nremote server: $server\n"
    ssh $server "cd $deploy_path; ./zkui.sh stop"
    echo
done
