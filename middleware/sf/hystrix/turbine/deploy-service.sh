#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=turbine-web-1.0.0.war

deploy_tomcat()
{
    cp tomcat/server.xml $tomcat_path/conf.$tomcat_version

    base_dir=`escape_slash $deploy_path/$component`
    sed "s/BASE_DIR/$base_dir/g" tomcat/start.sh \
        > tomcat/start.sh.tmp
    chmod a+x tomcat/start.sh.tmp
    cp tomcat/start.sh.tmp $tomcat_path/start.sh
    rm tomcat/start.sh.tmp

    cp tomcat/setenv.sh $tomcat_path

    sed "s/turbine_servers/tomcat_servers/g" ../servers-$scale.sh \
        > servers-$scale.sh.tmp
    chmod a+x servers-$scale.sh.tmp
    cp servers-$scale.sh.tmp $tomcat_path/../servers-$scale.sh
    rm servers-$scale.sh.tmp

    dp=`escape_slash $deploy_path`
    sed "s/DEPLOY_PATH/$dp/g" tomcat/common.sh \
        > tomcat/common.sh.tmp
    chmod a+x tomcat/common.sh.tmp
    cp tomcat/common.sh.tmp $tomcat_path/../common.sh
    rm tomcat/common.sh.tmp

    $tomcat_path/deploy-service.sh $scale

    git checkout -- $tomcat_path/../
}

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path/$component/conf"
    scp conf/config.properties $server:$deploy_path/$component/conf

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop tomcat"
    sleep $stop_start_interval
    scp ~/Software/hystrix/$deploy_file $server:$deploy_path/data/tomcat/$component.war
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start tomcat"
}

echo -e "\ndeploy tomcat\n"
deploy_tomcat

echo -e "\ndeploy $component\n"
batch_deploy

echo -e "\nrestart $component\n"
batch_restart
