#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

project_path=~/Projects/mydotey/artemis
project=artemis-package

init_db()
{
    cat conf/init.sql > conf/init.sql.tmp
    cat $project_path/$project/deployment/artemis-management.sql >> conf/init.sql.tmp
    mysql_db_exec conf/init.sql.tmp
    rm conf/init.sql.tmp
}

build()
{
    zone=$1
    server=$2

    sed "s/REGION/$region/g" conf/application.properties \
        | sed "s/ZONE/$zone/g" \
        | sed "s/PORT/$artemis_port/g" \
        > conf/application.properties.tmp

    declare c_n_s=`escape_slash "$cluster_node_setting"`
    sed "s/ARTEMIS_SERVICE_CLUSTER_NODES/$c_n_s/g" conf/artemis.properties \
        > conf/artemis.properties.tmp

    sed "s/MYSQL_DB_SERVER/$mysql_db_server/g" conf/data-source.properties \
        | sed "s/MYSQL_DB_USER/$mysql_db_user/g" \
        | sed "s/MYSQL_DB_PASSWORD/$mysql_db_password/g" \
        > conf/data-source.properties.tmp

    cd $project_path
    git checkout -- .
    git pull

    cp -f $work_path/conf/artemis.properties.tmp \
        $project/src/main/resources/artemis.properties
    cp -f $work_path/conf/application.properties.tmp \
        $project/src/main/resources/application.properties
    cp -f $work_path/conf/data-source.properties.tmp \
        $project/src/main/resources/data-source.properties

    mvn clean package -Dmaven.test.skip=true
    rm -f $project/target/*sources.jar
    rm -f $project/target/*javadoc.jar
    git checkout -- .

    cd $work_path
    rm conf/artemis.properties.tmp
    rm conf/application.properties.tmp
    rm conf/data-source.properties.tmp
}

remote_deploy()
{
    zone=$1
    server=$2

    ssh $server "echo '$PASSWORD' | sudo -S apt install -y openjdk-8-jdk"

    ssh $server "mkdir -p $deploy_path/$component"
    ssh $server "mkdir -p $deploy_path/logs/$component"

    scp $project_path/$project/target/artemis*.jar \
        $server:$deploy_path/$component/artemis.jar

    declare log_dir=`escape_slash "$deploy_path/logs/$component"`
    sed "s/LOG_DIR/$log_dir/g" start.sh \
        | sed "s/PORT/$artemis_port/g" \
        > start.sh.tmp
    chmod a+x start.sh.tmp
    scp start.sh.tmp $server:$deploy_path/$component/start.sh
    rm start.sh.tmp
}

batch_deploy()
{
    for zone in ${zones[@]}
    do
        declare c="echo \${${zone}_servers[@]}"
        declare zone_nodes=(`eval $c`)
        if [ ${#zone_nodes[@]} == 0 ]; then
            continue
        fi

        for node in ${zone_nodes[@]}
        do
            build $zone $node
            remote_deploy $zone $node
        done
    done
}

init_db

batch_deploy

batch_start
