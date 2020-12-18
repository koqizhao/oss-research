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

    declare origin_packaging="`escape_slash \"<packaging>jar</packaging>\"`"
    declare packaging="`escape_slash \"<packaging>war</packaging>\"`"
    sed "s/$origin_packaging/$packaging/g" $project_path/$project/pom.xml \
        > conf/pom.xml.tmp

    cd $project_path
    git checkout -- .
    git pull

    cp -f $work_path/conf/artemis.properties.tmp \
        $project/src/main/resources/artemis.properties
    cp -f $work_path/conf/application.properties.tmp \
        $project/src/main/resources/application.properties
    cp -f $work_path/conf/data-source.properties.tmp \
        $project/src/main/resources/data-source.properties
    cp -f $work_path/conf/pom.xml.tmp \
        $project/pom.xml

    mvn clean package -Dmaven.test.skip=true
    git checkout -- .

    cd $work_path
    rm conf/artemis.properties.tmp
    rm conf/application.properties.tmp
    rm conf/data-source.properties.tmp
    rm conf/pom.xml.tmp
}

deploy_tomcat()
{
    cp tomcat/server.xml $tomcat_path/conf.$tomcat_version
    cp tomcat/start.sh $tomcat_path
    cp tomcat/setenv.sh $tomcat_path

    sed "s/servers/tomcat_servers/g" ../servers-$scale.sh \
        > servers-$scale.sh.tmp
    chmod a+x servers-$scale.sh.tmp
    cp servers-$scale.sh.tmp $tomcat_path/../servers-$scale.sh
    rm servers-$scale.sh.tmp

    dp=`escape_slash $deploy_path`
    sed "s/DEPLOY_PATH/$dp/g" tomcat/common.sh \
        > tomcat/common.sh.tmp
    cp tomcat/common.sh.tmp $tomcat_path/../common.sh
    rm tomcat/common.sh.tmp

    $tomcat_path/deploy-service.sh $scale

    git checkout -- $tomcat_path/../
}

remote_deploy()
{
    zone=$1
    server=$2

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop $component"

    build $zone $server

    ssh $server "cd $deploy_path/$component/webapps; rm -rf ROOT; "
    scp $project_path/$project/target/artemis*.war \
        $server:$deploy_path/$component/webapps/ROOT.war

    ssh $server "echo '$PASSWORD' | sudo -S systemctl start $component"

    echo
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
            remote_deploy $zone $node
        done
    done
}

cp -r ../artemis/conf ./

init_db

deploy_tomcat

batch_deploy

rm -rf conf
