#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..
read_server_pass

source common.sh

t_servers=`escape_slash "$meta_servers"`
sed "s/META_SERVERS/$t_servers/g" apolloportaldb.sql \
    > apolloportaldb-temp.sql
db_exec apolloportaldb-temp.sql
rm apolloportaldb-temp.sql

scp_more()
{
    scp application-github.properties $1:$deploy_path
    scp apollo-env.properties $1:$deploy_path
}

batch_deploy
