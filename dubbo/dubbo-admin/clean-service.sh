#!/bin/bash

components=(admin)
deploy_path=/home/koqizhao/dubbo

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source ./servers.sh

for server in ${servers[@]}
do
    echo -e "\nclean started: $server\n"
    for c in ${components[@]}
    do
        component=dubbo-$c
        ssh $server "pid=\`ps aux | grep java | grep $component | awk '{ print \$2 }'\`; kill \$pid;"
        ssh $server "rm -rf $deploy_path/$component;"
    done
    echo -e "clean finished: $server\n"
done
