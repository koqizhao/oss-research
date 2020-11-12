#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $server "cd $deploy_path/$component; ./zkui.sh stop"
    ssh $server "rm -rf $deploy_path/$component"
}

batch_clean
