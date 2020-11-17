#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=prometheus-2.22.1.linux-amd64

generate_targets_config()
{
    declare tc=""
    for s in ${target_servers[@]}
    do
        if [ -z "$tc" ]; then
            tc="'$s:$target_port'"
        else
            tc="$tc, '$s:$target_port'"
        fi
    done
    echo $tc
}

target_servers=${alertmanager_servers[@]}
target_port=9093
amtc="`generate_targets_config`"
target_servers=${prometheus_servers[@]}
target_port=9090
ptc="`generate_targets_config`"
target_servers=${grafana_servers[@]}
target_port=3000
gtc="`generate_targets_config`"
target_servers=${node_exporter_servers[@]}
target_port=9100
ntc="`generate_targets_config`"
target_servers=${pushgateway_servers[@]}
target_port=9091
pgtc="`generate_targets_config`"
sed "s/TARGETS_ALERTMANAGER/$amtc/g" prometheus.yml \
    | sed "s/TARGETS_PROMETHEUS/$ptc/g" \
    | sed "s/TARGETS_GRAFANA/$gtc/g" \
    | sed "s/TARGETS_NODE_EXPORTER/$ntc/g" \
    | sed "s/TARGETS_PUSHGATEWAY/$pgtc/g" \
    > prometheus.yml.tmp

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/data/$component; mkdir -p $deploy_path/logs/$component"
    ssh $server "touch $deploy_path/logs/$component/$component.log; chmod a+w $deploy_path/logs/$component/$component.log"

    scp ~/Software/metric/prometheus/${deploy_file}.tar.gz $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf ${deploy_file}.tar.gz; mv $deploy_file $component; rm ${deploy_file}.tar.gz"

    sed "s/THANOS_REPLICA/$server/g" prometheus.yml.tmp \
        > prometheus.yml.tmp2
    scp prometheus.yml.tmp2 $server:$deploy_path/$component/prometheus.yml
    rm prometheus.yml.tmp2

    ssh $server "mkdir $deploy_path/$component/rules"
    scp rules/* $server:$deploy_path/$component/rules

    ssh $server "mkdir $deploy_path/$component/sd_configs"
    scp sd_configs/* $server:$deploy_path/$component/sd_configs

    scp start.sh $server:$deploy_path/$component

    scp prometheus.service $server:$deploy_path
    ssh $server "echo '$PASSWORD' | sudo -S chown root:root $deploy_path/prometheus.service"
    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/prometheus.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start prometheus.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable prometheus.service"
}

batch_deploy

rm prometheus.yml.tmp
