#!/bin/bash

components=(admin)
deploy_path=/home/koqizhao/dubbo

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source ./servers.sh

for server in ${servers[@]}
do
    echo -e "\nremote server: $server\n"
    for component in ${components[@]}
    do
        echo -e "component: $component"
        ssh $server "pid=\`ps aux | grep java | grep dubbo-$component | awk '{ print \$2 }'\`; kill \$pid;"
        ssh $server "ps aux | grep java | grep dubbo-$component"
        echo
    done
done
