#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_version=2
host_port=5000

remote_deploy()
{
    ssh $server "mkdir -p $deploy_path/data/$component"
    ssh $server "echo '$PASSWORD' | sudo -S docker run -d \
        -p $host_port:5000 \
        --restart=always \
        --name $component \
        -v $deploy_path/data/$component:/var/lib/registry \
        registry:$deploy_version"
}

batch_deploy
