#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_start()
{
    ssh $server "cd $deploy_path/$component; ./helm repo update; echo; ./helm --help;"
}

batch_start
