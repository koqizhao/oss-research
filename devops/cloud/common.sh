#!/bin/bash

deploy_path=/home/koqizhao/ops/cloud

read_server_pass

manager=koqizhao
servers=(`merge_array ${master_servers[@]} ${worker_servers[@]}`)

remote_status()
{
    remote_systemctl $1 status $2 $PASSWORD
}

remote_start()
{
    remote_enable $1 $2 $PASSWORD
}

remote_stop()
{
    remote_disable $1 $2 $PASSWORD
}
