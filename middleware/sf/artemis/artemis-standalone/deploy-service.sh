#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

project_path=~/Projects/mydotey/artemis
project=artemis-web

init_db()
{
    cat ../artemis/conf/init.sql > init.sql.tmp
    cat $project_path/$project/deployment/artemis-management.sql >> init.sql.tmp
    mysql_db_exec init.sql.tmp
    rm init.sql.tmp
}

build()
{
    zone=$1
    server=$2

    sed "s/REGION/$region/g" ../artemis/conf/application.properties \
        | sed "s/ZONE/$zone/g" \
        | sed "s/PORT/$artemis_port/g" \
        > application.properties.tmp

    declare c_n_s=`escape_slash "$cluster_node_setting"`
    sed "s/ARTEMIS_SERVICE_CLUSTER_NODES/$c_n_s/g" ../artemis/conf/artemis.properties \
        > artemis.properties.tmp

    sed "s/MYSQL_DB_SERVER/$mysql_db_server/g" ../artemis/conf/data-source.properties \
        | sed "s/MYSQL_DB_USER/$mysql_db_user/g" \
        | sed "s/MYSQL_DB_PASSWORD/$mysql_db_password/g" \
        > data-source.properties.tmp

    declare origin_packaging="`escape_slash \"<packaging>war</packaging>\"`"
    declare packaging="`escape_slash \"<packaging>jar</packaging>\"`"
    sed "s/$origin_packaging/$packaging/g" $project_path/$project/pom.xml \
        > pom.xml.tmp

    cd $project_path
    git checkout -- .
    git pull

    cp -f $work_path/artemis.properties.tmp \
        $project/src/main/resources/artemis.properties
    cp -f $work_path/application.properties.tmp \
        $project/src/main/resources/application.properties
    cp -f $work_path/data-source.properties.tmp \
        $project/src/main/resources/data-source.properties
    cp -f $work_path/pom.xml.tmp \
        $project/pom.xml

    mvn clean package -Dmaven.test.skip=true
    rm -f $project/target/*sources.jar
    git checkout -- .

    cd $work_path
    rm artemis.properties.tmp
    rm application.properties.tmp
    rm data-source.properties.tmp
    rm pom.xml.tmp
}

remote_deploy()
{
    zone=$1
    server=$2

    ssh $server "mkdir -p $deploy_path/$component"
    ssh $server "mkdir -p $deploy_path/logs/$component"

    scp $project_path/$project/target/artemis-web*.jar \
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
