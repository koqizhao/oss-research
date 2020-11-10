#!/bin/bash

components=(admin bootstrap)
deploy_path=/home/koqizhao/soul

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source ./servers.sh

for server in ${servers[@]}
do
    echo -e "\nclean started: $server\n"
    for c in ${components[@]}
    do
        component=soul-$c
        ssh $server "pid=\`ps aux | grep java | grep $component | awk '{ print \$2 }'\`; kill \$pid;"
    done
    ssh $server "rm -rf $deploy_path;"
    echo -e "clean finished: $server\n"
done
