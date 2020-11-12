#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..

source common.sh

project_path=~/Projects/apache/dubbo/dubbo-admin

cd $project_path
git checkout -- .
git pull
cp -f $work_path/application.properties dubbo-admin-server/src/main/resources/
mvn clean package -Dmaven.test.skip=true
git checkout -- .
cd $work_path

remote_deploy()
{
    server=$1
    component=$2
    deploy_file=$project_path/dubbo-admin-distribution/target/dubbo-admin-0.2.0-SNAPSHOT.jar

    ssh $server "mkdir -p $deploy_path/$component"
    scp $deploy_file $server:$deploy_path/$component
    scp start-$component.sh $server:$deploy_path/$component
    ssh $1 "cd $deploy_path/$component; ./start-$component.sh"
}

batch_deploy
