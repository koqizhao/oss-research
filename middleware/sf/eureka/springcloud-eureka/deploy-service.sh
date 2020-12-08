#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

project_path=~/Projects/koqizhao/java-projects/spring-cloud-study
project=spring-cloud-eureka

build()
{
    declare e_s_u=`escape_slash "$eureka_service_url"`
    sed "s/REGION/$region/g" conf/application.yml.$scale \
        | sed "s/PORT/$eureka_port/g" \
        | sed "s/EUREKA_SERVICE_URL/$e_s_u/g" \
        > conf/application.yml

    cd $project_path
    git checkout -- .
    git pull

    cp -f $work_path/conf/application.yml $project/src/main/resources
    cp -f $work_path/conf/bootstrap.yml $project/src/main/resources

    mvn clean package -Dmaven.test.skip=true
    git checkout -- .

    cd $work_path
    rm conf/application.yml
}

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path/$component"
    ssh $server "mkdir -p $deploy_path/logs/$component"

    scp $project_path/$project/target/eureka.jar $server:$deploy_path/$component

    declare log_dir=`escape_slash "$deploy_path/logs/$component"`
    sed "s/LOG_DIR/$log_dir/g" start.sh \
        > start.sh.tmp
    chmod a+x start.sh.tmp
    scp start.sh.tmp $server:$deploy_path/$component/start.sh
    rm start.sh.tmp
}

build

batch_deploy

batch_start
