#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

project_path=/home/koqizhao/Projects/prometheus/jmx_exporter
deploy_file=jmx_prometheus_httpserver-0.14.1-SNAPSHOT-jar-with-dependencies.jar

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/$component; mkdir -p $deploy_path/logs/$component"
    ssh $server "touch $deploy_path/logs/$component/$component.log; chmod a+w $deploy_path/logs/$component/$component.log"

    scp $project_path/jmx_prometheus_httpserver/target/$deploy_file $server:$deploy_path/$component/jmx_prometheus_httpserver.jar
    scp kafka.yml $server:$deploy_path/$component
    scp start.sh $server:$deploy_path/$component

    dp=`escape_slash $deploy_path/$component`
    lp=`escape_slash $deploy_path/logs/$component`
    sed "s/DEPLOY_PATH/$dp/g" $component.service \
        | sed "s/LOG_PATH/$lp/g" \
        > $component.service.tmp
    scp $component.service.tmp $server:$deploy_path/$component.service
    rm $component.service.tmp

    ssh $server "echo '$PASSWORD' | sudo -S chown root:root $deploy_path/$component.service"
    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/$component.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start $component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable $component.service"
}

batch_deploy
