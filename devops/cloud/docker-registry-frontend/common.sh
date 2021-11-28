#!/bin/bash

source ../common.sh

component=docker-registry-frontend
servers=(${worker_servers[0]})

deploy_image=konradkleine/docker-registry-frontend
deploy_tag=v2

remote_stop()
{
    ssh $1 "echo '$PASSWORD' | sudo -S docker container stop $component"
}
