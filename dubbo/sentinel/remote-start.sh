#!/bin/bash

components=(dashboard)
deploy_path=/home/koqizhao/sentinel

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source ./servers.sh

for server in ${servers[@]}
do
    echo -e "\nremote server: $server\n"
    for component in ${components[@]}
    do
        echo -e "\ncomponent: $component\n"
        ssh $server "cd $deploy_path; ./start-sentinel-$component.sh"
        ssh $server "ps aux | grep java | grep sentinel-$component"
        echo
    done
done
