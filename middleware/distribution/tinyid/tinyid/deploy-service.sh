#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

project_path=~/Projects/misc/tinyid
project=tinyid-server
profile=offline

log_dir=`escape_slash $deploy_path/logs/$component`

build()
{
    sed "s/LOG_DIR/$log_dir/g" conf/$profile/log4j2.xml \
        > conf/$profile/log4j2.xml.tmp

    sed "s/MYSQL_DB_SERVER/$mysql_db_server/g" conf/$profile/application.properties \
        | sed "s/MYSQL_DB_USER/$mysql_db_user/g" \
        | sed "s/MYSQL_DB_PASSWORD/$mysql_db_password/g" \
        > conf/$profile/application.properties.tmp

    cd $project_path
    git checkout -- .
    git pull

    cp -f $work_path/conf/$profile/log4j2.xml.tmp $project/src/main/resources/$profile/log4j2.xml
    cp -f $work_path/conf/$profile/application.properties.tmp \
        $project/src/main/resources/$profile/application.properties

    cd $project
    sh build.sh $profile

    cd ..
    git checkout -- .

    cd $work_path
    rm conf/$profile/log4j2.xml.tmp
    rm conf/$profile/application.properties.tmp
}

init_db()
{
    cp init.sql init.sql.tmp
    echo >> init.sql.tmp
    cat $project_path/$project/db.sql >> init.sql.tmp
    mysql_db_exec init.sql.tmp
    rm init.sql.tmp
}

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path/$component"
    ssh $server "mkdir -p $deploy_path/logs/$component"

    scp $project_path/$project/output/tinyid-server-*.jar \
        $server:$deploy_path/$component/tinyid-server.jar

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
