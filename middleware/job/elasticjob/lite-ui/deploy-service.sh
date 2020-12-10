#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file_name=apache-shardingsphere-elasticjob-$deploy_version-$component-bin
deploy_file=$deploy_file_name.tar.gz

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/logs/$component"

    scp ~/Software/elasticjob/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $deploy_file; mv $deploy_file_name $component; rm $deploy_file;"

    scp bin/* $server:$deploy_path/$component/bin
    scp conf/* $server:$deploy_path/$component/conf
    scp start.sh $server:$deploy_path/$component

    ssh $server "mkdir -p ~/.elasticjob-console"
    sed "s/ZK_CONNECT/$registry_center_address/g" data/Configurations.xml \
        | sed "s/ZK_NAMESPACE/$registry_namespace/g" \
        > data/Configurations.xml.tmp
    scp data/Configurations.xml.tmp $server:./.elasticjob-console/Configurations.xml
    rm data/Configurations.xml.tmp
}

batch_deploy

batch_start
