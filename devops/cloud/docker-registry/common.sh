#!/bin/bash

source ../common.sh

component=docker-registry
servers=(${worker_servers[0]})

deploy_image=registry
deploy_tag=2

remote_stop()
{
    ssh $1 "echo '$PASSWORD' | sudo -S docker container stop $component"
}
