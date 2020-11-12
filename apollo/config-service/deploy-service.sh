#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..
read_server_pass

source common.sh

t_url=`escape_slash "$eureka_url"`
sed "s/EUREKA_SERVICE_URL/$t_url/g" apolloconfigdb.sql \
    > apolloconfigdb-temp.sql
db_exec apolloconfigdb-temp.sql
rm apolloconfigdb-temp.sql

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
