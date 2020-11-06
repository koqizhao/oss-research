#!/bin/bash

components=(admin bootstrap)
deploy_path=/home/koqizhao/soul

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source ./servers.sh

for server in ${servers[@]}
do
    echo  "remote server: $server"
    for component in ${components[@]}
    do
        echo -e "component: $component"
        ssh $server "cd $deploy_path; ./start-soul-$component.sh"
        ssh $server "ps aux | grep java | grep soul-$component"
        echo
    done
done
