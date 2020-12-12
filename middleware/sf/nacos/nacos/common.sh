#!/bin/bash

source ../common.sh

component=nacos

remote_status()
{
    remote_ps $1 $2
}

remote_start()
{
    ssh $1 "cd $deploy_path/$component; ./start.sh"
}

remote_stop()
{
    ssh $1 "cd $deploy_path/$component; bin/shutdown.sh"
}
