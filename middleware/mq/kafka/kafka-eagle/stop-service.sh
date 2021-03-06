#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_stop()
{
    ssh $1 "cd $deploy_path/$2; sh ./start.sh stop"
}

batch_stop
