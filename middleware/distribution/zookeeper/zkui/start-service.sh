#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_start()
{
    server=$1
    ssh $server "cd $deploy_path/$component; ./zkui.sh start"
}

batch_start
