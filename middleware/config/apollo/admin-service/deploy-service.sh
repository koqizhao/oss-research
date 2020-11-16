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
        | sed "s/MYSQL_SERVER/$mysql_db_server/g" \
        | sed "s/MYSQL_USER/$mysql_db_user/g" \
        | sed "s/MYSQL_PASSWORD/$mysql_db_password/g" \
        > application-github.properties.tmp
    scp application-github.properties.tmp $1:$deploy_path/application-github.properties
    rm application-github.properties.tmp
}

batch_deploy
