#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

project_path=~/Projects/apache/rocketmq-externals
deploy_file=rocketmq-console-ng-2.0.0.jar

build()
{
    cd $project_path
    git checkout -- .
    git pull
    cd $component
    mvn clean package -Dmaven.test.skip=true
    cd $work_path
}

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path/$component"
    ssh $server "mkdir -p $deploy_path/data/$component"

    scp $project_path/$component/target/$deploy_file $server:$deploy_path/$component

    data_dir=`escape_slash $deploy_path/data/$component`
    sed "s/NS_ADDRESS/$namesrv_addr/g" start.sh \
        | sed "s/DEPLOY_FILE/$deploy_file/g" \
        | sed "s/DATA_DIR/$data_dir/g" \
        > start.sh.tmp
    chmod a+x start.sh.tmp
    scp start.sh.tmp $server:$deploy_path/$component/start.sh
    rm start.sh.tmp
}

#build

batch_deploy

batch_start
