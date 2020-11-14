#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=thanos-0.16.0.linux-amd64

for server in ${all_servers[@]}
do
    ssh $server "mkdir -p $deploy_path/data/$parent_component; mkdir -p $deploy_path/logs/$parent_component"

    scp ~/Software/metric/${deploy_file}.tar.gz $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf ${deploy_file}.tar.gz; mv $deploy_file $parent_component; rm ${deploy_file}.tar.gz"
done

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path/data/$parent_component/$component; mkdir -p $deploy_path/logs/$parent_component/$component"
    ssh $server "touch $deploy_path/logs/$parent_component/$component/$component.log; chmod a+w $deploy_path/logs/$parent_component/$component/$component.log"
    ssh $server "mkdir -p $deploy_path/$parent_component/$component"
    source $component/custom_scp_script.sh

    scp $component/$component.service $server:$deploy_path/$parent_component/$component
    ssh $server "echo '$PASSWORD' | sudo -S chown root:root $deploy_path/$parent_component/$component/$component.service"
    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/$parent_component/$component/$component.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start $component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable $component.service"
}

component=thanos-sidecar
servers=${thanos_sidecar_servers[@]}
batch_deploy

component=thanos-query
servers=${thanos_query_servers[@]}
batch_deploy
