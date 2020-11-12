#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..

source common.sh

start()
{
    server=$1
    ssh $server "cd $deploy_path/$component; ./zkui.sh start"
}

remote_start
