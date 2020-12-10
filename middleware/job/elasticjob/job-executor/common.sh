#!/bin/bash

source ../common.sh

component=job-executor
servers=(${executor_servers[@]})

remote_start()
{
    ssh $1 "cd $deploy_path/$component; ./start.sh; "
}

remote_stop()
{
    remote_kill $1 my-job
}

remote_status()
{
    remote_ps $1 my-job
}
