#!/bin/bash

component=configservice
deploy_path=/home/koqizhao/apollo
servers=$@

for server in ${servers[@]}
do
    echo -e "\nremote server: $server\n"
    ssh $server "cd $deploy_path/$component; scripts/shutdown.sh;"
    echo
    sleep 1
    ssh $server "ps aux | grep $component"
    echo
done
