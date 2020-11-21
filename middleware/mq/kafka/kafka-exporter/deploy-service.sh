#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=kafka_exporter-1.2.0.linux-amd64

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path"

    scp ~/Software/kafka/${deploy_file}.tar.gz $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf ${deploy_file}.tar.gz; mv $deploy_file $component; rm ${deploy_file}.tar.gz"

    scp stop.sh $server:$deploy_path/$component

    sed "s/KAFKA_SERVER/$server/g" start.sh > start.sh.tmp
    chmod a+x start.sh.tmp
    scp start.sh.tmp $server:$deploy_path/$component/start.sh
    rm start.sh.tmp

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
