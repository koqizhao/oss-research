#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file_name=apache-shardingsphere-$deploy_version-$component-bin
deploy_file=$deploy_file_name.tar.gz

init_ds()
{
    mysql_db_exec data/demo_ds.sql
}

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/logs/$component"

    scp ~/Software/shardingsphere/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $deploy_file; mv $deploy_file_name $component; rm $deploy_file;"
    scp ~/Software/shardingsphere/$mysql_connector_file $server:$deploy_path/$component/lib

    scp bin/* $server:$deploy_path/$component/bin
    scp conf/* $server:$deploy_path/$component/conf
    scp start.sh $server:$deploy_path/$component

    sed "s/REGISTRY_CENTER_TYPE/$registry_center_type/g" conf/server.yaml \
        | sed "s/REGISTRY_CENTER_ADDRESS/$registry_center_address/g" \
        > conf/server.yaml.tmp
    scp conf/server.yaml.tmp $server:$deploy_path/$component/conf/server.yaml
    rm conf/server.yaml.tmp
}

init_ds

batch_deploy

batch_start
