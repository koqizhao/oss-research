#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
}

batch_stop
batch_clean
