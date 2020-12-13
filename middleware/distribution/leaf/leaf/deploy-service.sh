#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

project_path=~/Projects/dianping/Leaf
project=leaf-server

log_dir=`escape_slash $deploy_path/logs/$component`

build()
{
    sed "s/MYSQL_DB_SERVER/$mysql_db_server/g" conf/leaf.properties \
        | sed "s/MYSQL_DB_USER/$mysql_db_user/g" \
        | sed "s/MYSQL_DB_PASSWORD/$mysql_db_password/g" \
        | sed "s/ZK_CONNECT/$zk_connect/g" \
        > conf/leaf.properties.tmp

    cd $project_path
    git checkout -- .
    git pull

    cp -f $work_path/conf/leaf.properties.tmp $project/src/main/resources/leaf.properties
    cp -f $work_path/conf/application.properties $project/src/main/resources/application.properties

    mvn clean package -Dmaven.test.skip=true

    git checkout -- .

    cd $work_path
    rm conf/leaf.properties.tmp
}

init_db()
{
    cp init.sql init.sql.tmp
    echo >> init.sql.tmp
    cat $project_path/scripts/leaf_alloc.sql >> init.sql.tmp
    echo >> init.sql.tmp
    cat init-data.sql >> init.sql.tmp
    mysql_db_exec init.sql.tmp
    rm init.sql.tmp
}

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path/$component"
    ssh $server "mkdir -p $deploy_path/logs/$component"

    scp $project_path/$project/target/leaf.jar $server:$deploy_path/$component

    sed "s/LOG_DIR/$log_dir/g" start.sh \
        > start.sh.tmp
    chmod a+x start.sh.tmp
    scp start.sh.tmp $server:$deploy_path/$component/start.sh
    rm start.sh.tmp
}

build

init_db

batch_deploy

batch_start
