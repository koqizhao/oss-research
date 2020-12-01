#!/bin/bash

source ../common.sh

component=apisix-dashboard
servers=(${dashboard_servers[@]})

remote_status()
{
    remote_ps $1 manager-api
}

remote_start()
{
    ssh $server "cd $deploy_path/$component; sh start.sh; "
}

remote_stop()
{
    ssh $1 "pid=\`ps aux | grep manager-api | awk '{ print \$2 }'\`; kill \$pid;"
}
