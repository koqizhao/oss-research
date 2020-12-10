#!/bin/bash

source ../common.sh

component=shardingsphere-proxy

remote_start()
{
    ssh $1 "cd $deploy_path/$component; ./start.sh;"
}

remote_stop()
{
    ssh $1 "cd $deploy_path/$component; bin/stop.sh;"
}

remote_status()
{
    remote_ps $1 $component
}
