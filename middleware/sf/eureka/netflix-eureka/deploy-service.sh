#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

project_path=~/Projects/netflix/eureka
project=eureka-server

build()
{
    declare e_s_u=`escape_slash "$eureka_service_url"`
    sed "s/REGION/$region/g" conf/eureka-client.properties \
        | sed "s/PORT/$eureka_port/g" \
        | sed "s/EUREKA_SERVICE_URL/$e_s_u/g" \
        > conf/eureka-client.properties.tmp

    cd $project_path
    git checkout -- .
    git pull

    cp -f $work_path/conf/eureka-client.properties.tmp \
        $project/src/main/resources/eureka-client.properties
    cp -f $work_path/conf/eureka-server.properties $project/src/main/resources
    cp -f $work_path/conf/log4j.properties $project/src/main/resources

    gradle clean build -x test
    git checkout -- .

    cd $work_path
    rm conf/eureka-client.properties.tmp
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
    server=$1
    component=$2

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop $component"

    sleep $stop_start_interval

    scp $project_path/$project/build/libs/eureka-server*.war \
        $server:$deploy_path/$component/webapps/eureka.war

    ssh $server "echo '$PASSWORD' | sudo -S systemctl start $component"
}

build

deploy_tomcat

batch_deploy
