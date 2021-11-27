#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_status()
{
    ssh $server "cd $deploy_path/$component; ./helm version; echo; ./helm repo list;"
}

batch_status
