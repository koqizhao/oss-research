#!/bin/bash

components=(admin)
deploy_path=/home/koqizhao/dubbo

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source ./servers.sh

for server in ${servers[@]}
do
    echo  "remote server: $server"
    for c in ${components[@]}
    do
        component=dubbo-$c
        echo -e "component: $component"
        ssh $server "cd $deploy_path/$component; ./start-$component.sh"
        ssh $server "ps aux | grep java | grep $component"
        echo
    done
done
