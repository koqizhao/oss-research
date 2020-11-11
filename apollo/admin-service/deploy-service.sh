#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..
read_server_pass

source common.sh

deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path"

    scp $deploy_file $server:$deploy_path
    scp app.properties $server:$deploy_path
    scp startup.sh $server:$deploy_path
    scp deploy.sh $server:$deploy_path

    sed "s/SERVER_IP/$server/g" application-github.properties \
        | sed "s/SERVER_NAME/$server/g" \
        > temp.properties
    scp temp.properties $server:$deploy_path/application-github.properties
    rm temp.properties

    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S sh deploy.sh $component; rm deploy.sh;"
}

remote_deploy
