#!/bin/bash

servers=$@
appId=100003171
deploy_path=/home/koqizhao/apollo/configservice

for server in ${servers[@]}
do
    echo -e "\nclean started: $server\n"
    ssh $server "cd $deploy_path; scripts/shutdown.sh;"
    ssh $server "rm -rf $deploy_path; rm -rf /opt/logs/$appId"
    echo -e "clean finished: $server\n"
done
