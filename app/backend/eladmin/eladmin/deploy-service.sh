#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

project_path=~/Projects/misc/eladmin/eladmin
project=eladmin-system

init_db()
{
    cat conf/init.sql > conf/init.sql.tmp
    cat $project_path/sql/eladmin.sql >> conf/init.sql.tmp
    mysql_db_exec conf/init.sql.tmp
    rm conf/init.sql.tmp
}

build()
{
    sed "s/SERVER_PORT/$server_port/g" conf/application.yml \
        | sed "s/REDIS_DB_SERVER/$redis_db_server/g" \
        | sed "s/REDIS_DB_PORT/$redis_db_port/g" \
        | sed "s/REDIS_DB_PASSWORD/$redis_db_password/g" \
        > conf/application.yml.tmp

    declare data_dir=`escape_slash "$deploy_path/data/$component"`
    sed "s/MYSQL_DB_SERVER/$mysql_db_server/g" conf/application-dev.yml \
        | sed "s/MYSQL_DB_USER/$mysql_db_user/g" \
        | sed "s/MYSQL_DB_PASSWORD/$mysql_db_password/g" \
        | sed "s/DATA_DIR/$data_dir/g" \
        > conf/application-dev.yml.tmp

    cd $project_path
    git checkout -- .
    #git pull

    cp -f $work_path/conf/application.yml.tmp \
        $project/src/main/resources/config/application.yml
    cp -f $work_path/conf/application-dev.yml.tmp \
        $project/src/main/resources/config/application-dev.yml

    mvn clean package -Dmaven.test.skip=true
    rm -f $project/target/*sources.jar
    rm -f $project/target/*javadoc.jar
    git checkout -- .

    cd $work_path
    rm conf/application.yml.tmp
    rm conf/application-dev.yml.tmp
}

remote_deploy()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S apt install -y openjdk-8-jdk"

    ssh $server "mkdir -p $deploy_path/$component"
    ssh $server "mkdir -p $deploy_path/logs/$component"
    ssh $server "mkdir -p $deploy_path/data/$component"

    scp $project_path/$project/target/eladmin*.jar \
        $server:$deploy_path/$component/eladmin.jar

    declare log_dir=`escape_slash "$deploy_path/logs/$component"`
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
