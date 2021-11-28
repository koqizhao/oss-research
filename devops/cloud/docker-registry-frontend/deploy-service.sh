#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

registry_host=${servers[0]}
registry_port=5000

host_port=5080

remote_deploy()
{
    ssh $server "mkdir -p $deploy_path/data/$component"
    ssh $server "echo '$PASSWORD' | sudo -S docker run -d \
        -p $host_port:80 \
        --restart=always \
        --name $component \
        -e ENV_DOCKER_REGISTRY_HOST=$registry_host \
        -e ENV_DOCKER_REGISTRY_PORT=$registry_port \
        $deploy_image:$deploy_tag"
}

batch_deploy
