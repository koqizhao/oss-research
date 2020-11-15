#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=node_exporter-1.0.1.linux-amd64

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/data/$component; mkdir -p $deploy_path/logs/$component"
    ssh $server "touch $deploy_path/logs/$component/$component.log; chmod a+w $deploy_path/logs/$component/$component.log"

    scp ~/Software/metric/prometheus/${deploy_file}.tar.gz $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf ${deploy_file}.tar.gz; mv $deploy_file $component; rm ${deploy_file}.tar.gz"

    scp start.sh $server:$deploy_path/$component

    scp $component.service $server:$deploy_path/$component
    ssh $server "echo '$PASSWORD' | sudo -S chown root:root $deploy_path/$component/$component.service"
    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/$component/$component.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start $component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable $component.service"

}

batch_deploy
