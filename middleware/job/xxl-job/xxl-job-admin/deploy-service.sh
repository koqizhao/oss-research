#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

project_path=~/Projects/misc/xxl-job

deploy_file=xxl-job-admin-2.3.0-SNAPSHOT.jar
log_dir=`escape_slash $deploy_path/logs/$component`

init_db()
{
    mysql_db_exec $project_path/doc/db/tables_xxl_job.sql
}

build()
{
    sed "s/LOG_DIR/$log_dir/g" conf/logback.xml \
        > conf/logback.xml.tmp
    sed "s/MYSQL_DB_SERVER/$mysql_db_server/g" conf/application.properties \
        | sed "s/MYSQL_DB_USER/$mysql_db_user/g" \
        | sed "s/MYSQL_DB_PASSWORD/$mysql_db_password/g" \
        > conf/application.properties.tmp
 
    cd $project_path
    git checkout -- .
    git pull
    cp $work_path/conf/logback.xml.tmp \
        $project_path/xxl-job-admin/src/main/resources/logback.xml
    cp $work_path/conf/application.properties.tmp \
        $project_path/xxl-job-admin/src/main/resources/application.properties
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

    scp $project_path/xxl-job-admin/target/xxl-job-admin*.jar \
        $server:$deploy_path/$component/xxl-job-admin.jar

    sed "s/LOG_DIR/$log_dir/g" start.sh \
        > start.sh.tmp
    chmod a+x start.sh.tmp
    scp start.sh.tmp $server:$deploy_path/$component/start.sh
    rm start.sh.tmp
}

init_db

build

batch_deploy

batch_start
