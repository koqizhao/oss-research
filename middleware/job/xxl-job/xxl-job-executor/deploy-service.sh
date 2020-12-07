#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

project=xxl-job-executor-samples/xxl-job-executor-sample-springboot
log_dir=`escape_slash $deploy_path/logs/$component`

build()
{
    sed "s/LOG_DIR/$log_dir/g" conf/logback.xml \
        > conf/logback.xml.tmp
    declare admin_addr=`escape_slash "$admin_addresses"`
    sed "s/ADMIN_ADDRESSES/$admin_addr/g" conf/application.properties \
        | sed "s/LOG_DIR/$log_dir/g" \
        > conf/application.properties.tmp
 
    cd $project_path
    git checkout -- .
    git pull
    cp $work_path/conf/logback.xml.tmp \
        $project_path/$project/src/main/resources/logback.xml
    cp $work_path/conf/application.properties.tmp \
        $project_path/$project/src/main/resources/application.properties
    mvn clean package -Dmaven.test.skip=true
    git checkout -- .
    cd $work_path

    rm conf/*.tmp
}

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/$component"
    ssh $server "mkdir -p $deploy_path/logs/$component"

    scp $project_path/$project/target/xxl-job-executor-sample-springboot*.jar \
        $server:$deploy_path/$component/xxl-job-executor-sample-springboot.jar

    sed "s/LOG_DIR/$log_dir/g" start.sh \
        | sed "s/SERVER_IP/$server/g" \
        > start.sh.tmp
    chmod a+x start.sh.tmp
    scp start.sh.tmp $server:$deploy_path/$component/start.sh
    rm start.sh.tmp
}

build

batch_deploy

batch_start
