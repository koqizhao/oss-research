#!/bin/bash

source ../common.sh

component=leaf
zk_connect=192.168.56.11:2181

remote_status()
{
    remote_ps $1 $2
}

remote_start()
{
    ssh $1 "cd $deploy_path/$component; ./start.sh; "
}

remote_stop()
{
    remote_kill $1 $2
}
