#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    remote_stop $server $component
    ssh $server "echo '$PASSWORD' | sudo -S docker container rm -v $component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/data/$component"
}

batch_clean
