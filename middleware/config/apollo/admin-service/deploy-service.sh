#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..
read_server_pass

source common.sh

scp_more()
{
    server=$1

    sed "s/SERVER_IP/$server/g" application-github.properties \
        | sed "s/SERVER_NAME/$server/g" \
        > temp.properties
    scp temp.properties $server:$deploy_path/application-github.properties
    rm temp.properties
}

batch_deploy
