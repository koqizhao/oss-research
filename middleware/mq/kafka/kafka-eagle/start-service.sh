#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_start()
{
    ssh $1 "cd $deploy_path/$2; sh ./start.sh start"
}

batch_start
