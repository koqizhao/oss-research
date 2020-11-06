#!/bin/bash

components=(dashboard)
deploy_path=/home/koqizhao/sentinel

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
        ssh $server "pid=\`ps aux | grep java | grep sentinel-$component | awk '{ print \$2 }'\`; kill \$pid;"
        ssh $server "ps aux | grep java | grep sentinel-$component"
        echo
    done
done
