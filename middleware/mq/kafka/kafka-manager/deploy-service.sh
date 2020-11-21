#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=kafka-manager-2.0.0.2

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path"

    scp ~/Software/kafka/${deploy_file}.zip $server:$deploy_path
    ssh $server "cd $deploy_path; unzip ${deploy_file}.zip; mv $deploy_file $component; rm ${deploy_file}.zip"

    sed "s/ZOOKEEPER_CONNECT/$zk_connect/g" application.conf > application.conf.tmp
    scp application.conf.tmp $server:$deploy_path/$component/conf/application.conf
    rm application.conf.tmp

    dp=`escape_slash $deploy_path/$component`
    sed "s/DEPLOY_PATH/$dp/g" $component.service \
        > $component.service.tmp
    scp $component.service.tmp $server:$deploy_path/$component/$component.service
    rm $component.service.tmp

    ssh $server "echo '$PASSWORD' | sudo -S chown root:root $deploy_path/$component/$component.service"
    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/$component/$component.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start $component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable $component.service"
}

batch_deploy
