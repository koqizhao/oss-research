#!/bin/bash

deploy_path=/home/koqizhao/zookeeper/zkui

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source ./servers.sh

for server in ${servers[@]}
do
    echo -e "clean started: $server\n"
    ssh $server "cd $deploy_path; ./zkui.sh stop"
    ssh $server "rm -rf $deploy_path"
    echo -e "clean finished: $server\n"
done
