#!/bin/bash

source ../common.sh

component=tinyid

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
