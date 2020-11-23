#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=kafka_2.13-2.6.0

remote_deploy()
{
    server=$1
    id=`echo $server | awk -F '.' '{ print $4 }'`

    ssh $server "mkdir -p $deploy_path/data"

    scp ~/Software/kafka/${deploy_file}.tgz $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf ${deploy_file}.tgz; mv $deploy_file $component; rm ${deploy_file}.tgz"

    dp=`escape_slash $deploy_path/data`
    sed "s/BROKER_ID/$id/g" config/server.properties \
        | sed "s/LOG_DIRS/$dp/g" \
        | sed "s/HOST_IP/$server/g" \
        | sed "s/ZOOKEEPER_CONNECT/$zk_connect/g" \
        > server.properties
    scp server.properties $server:$deploy_path/$component/config
    rm server.properties

    #scp config/log4j.properties $server:$deploy_path/$component/config

    scp config/kafka-env.sh $server:$deploy_path/$component
    scp kafka.sh $server:$deploy_path/$component

    dp=`escape_slash $deploy_path/$component`
    sed "s/DEPLOY_PATH/$dp/g" kafka.service \
        > kafka.service.tmp
    scp kafka.service.tmp $server:$deploy_path/$component/kafka.service
    rm kafka.service.tmp

    ssh $server "echo '$PASSWORD' | sudo -S chown root:root $deploy_path/$component/kafka.service"
    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/$component/kafka.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start kafka.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable kafka.service"
}

batch_deploy
