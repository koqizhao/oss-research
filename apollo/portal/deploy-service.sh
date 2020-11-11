#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..
read_server_pass

source common.sh

t_servers=`escape_slash "$meta_servers"`
sed "s/META_SERVERS/$t_servers/g" apolloportaldb.sql \
    > apolloportaldb-temp.sql
db_exec apolloportaldb-temp.sql
rm apolloportaldb-temp.sql

deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path"

    scp $deploy_file $server:$deploy_path
    scp app.properties $server:$deploy_path
    scp application-github.properties $server:$deploy_path
    scp apollo-env.properties $server:$deploy_path
    scp startup.sh $server:$deploy_path
    scp deploy.sh $server:$deploy_path

    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S sh deploy.sh $component; rm deploy.sh;"
}

remote_deploy
