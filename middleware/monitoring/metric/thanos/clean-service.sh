#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop $component"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl disable $component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -f /etc/systemd/system/$component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$parrent_component/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/data/$parrent_component/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/logs/$parrent_component/$component"
}

component=thanos-query
servers=${thanos_query_servers[@]}
batch_clean

component=thanos-sidecar
servers=${thanos_sidecar_servers[@]}
batch_clean

for server in ${all_servers[@]}
do
    ssh $server "rm -rf $deploy_path/$parent_component"
    ssh $server "rm -rf $deploy_path/data/$parent_component; rm -rf $deploy_path/logs/$parent_component"
done
