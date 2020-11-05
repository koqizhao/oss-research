#!/bin/bash

servers=$@
appId=100003173
deploy_path=/home/koqizhao/apollo/portal

for server in ${servers[@]}
do
    echo -e "clean started: $server\n"
    ssh $server "cd $deploy_path; scripts/shutdown.sh;"
    ssh $server "rm -rf $deploy_path; rm -rf /opt/logs/$appId"
    echo -e "clean finished: $server\n"
done
