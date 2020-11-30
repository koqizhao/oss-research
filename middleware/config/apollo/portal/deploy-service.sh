#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..
read_server_pass

source common.sh

t_servers=`escape_slash "$meta_servers"`
sed "s/META_SERVERS/$t_servers/g" apolloportaldb.sql \
    > apolloportaldb-temp.sql
mysql_db_exec apolloportaldb-temp.sql
rm apolloportaldb-temp.sql

scp_more()
{
    sed "s/MYSQL_SERVER/$mysql_db_server/g" application-github.properties \
        | sed "s/MYSQL_USER/$mysql_db_user/g" \
        | sed "s/MYSQL_PASSWORD/$mysql_db_password/g" \
        > application-github.properties.tmp
    scp application-github.properties.tmp $1:$deploy_path/application-github.properties
    rm application-github.properties.tmp

    scp apollo-env.properties $1:$deploy_path
}

batch_deploy
