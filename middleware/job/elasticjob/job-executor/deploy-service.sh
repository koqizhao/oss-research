#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

project_path=/home/koqizhao/Projects/koqizhao/java-projects/study
project=elasticjob
log_dir=`escape_slash $deploy_path/logs/$component`

build()
{
    cd $project_path
    git checkout -- .
    git pull
    mvn clean package -Dmaven.test.skip=true
    git checkout -- .
    cd $work_path
}

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/$component"
    ssh $server "mkdir -p $deploy_path/logs/$component"

    scp $project_path/$project/target/my-job.one-jar.jar \
        $server:$deploy_path/$component/my-job.jar

    sed "s/LOG_DIR/$log_dir/g" start.sh \
        > start.sh.tmp
    chmod a+x start.sh.tmp
    scp start.sh.tmp $server:$deploy_path/$component/start.sh
    rm start.sh.tmp
}

#build

batch_deploy

batch_start
