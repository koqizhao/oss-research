#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=prometheus-2.22.1.linux-amd64

ams=""
for am in ${alertmanager_servers[@]}
do
    if [ -z "$ams" ]; then
        ams="'$am:9093'"
    else
        ams="$ams, '$am:9093'"
    fi
done

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/data/$component; mkdir -p $deploy_path/logs/$component"
    ssh $server "touch $deploy_path/logs/$component/$component.log; chmod a+w $deploy_path/logs/$component/$component.log"

    scp ~/Software/metric/prometheus/${deploy_file}.tar.gz $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf ${deploy_file}.tar.gz; mv $deploy_file $component; rm ${deploy_file}.tar.gz"

    sed "s/THANOS_REPLICA/$server/g" prometheus.yml \
        | sed "s/ALERT_MANAGERS/$ams/g" \
        > prometheus.yml.tmp
    scp prometheus.yml.tmp $server:$deploy_path/$component/prometheus.yml
    rm prometheus.yml.tmp

    ssh $server "mkdir $deploy_path/$component/rules"
    scp rules/* $server:$deploy_path/$component/rules
    scp start.sh $server:$deploy_path/$component

    scp prometheus.service $server:$deploy_path
    ssh $server "echo '$PASSWORD' | sudo -S chown root:root $deploy_path/prometheus.service"
    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/prometheus.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start prometheus.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable prometheus.service"
}

batch_deploy