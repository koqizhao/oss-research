#!/bin/bash

component=configservice
deploy_path=/home/koqizhao/apollo
servers=(192.168.56.11 192.168.56.12)

for server in ${servers[@]}
do
    echo "remote server: $server"
    ssh $server "cd $deploy_path/$component; scripts/startup.sh"
    echo
    sleep 1
    ssh $server "ps aux | grep $component"
    echo
done
