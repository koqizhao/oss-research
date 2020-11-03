#!/bin/bash

component=portal
deploy_path=/home/koqizhao/apollo
servers=(192.168.56.11)

for server in ${servers[@]}
do
    echo "remote server: $server"
    ssh $server "cd $deploy_path/$component; scripts/shutdown.sh;"
    echo
    sleep 1
    ssh $server "ps aux | grep $component"
    echo
done
