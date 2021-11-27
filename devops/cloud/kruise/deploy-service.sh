#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_version=v0.10.0
deploy_file=kruise-chart.tgz
wget https://github.com/openkruise/kruise/releases/download/$deploy_version/$deploy_file

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path/$component"
    scp $deploy_file $server:$deploy_path/$component
    ssh $server "cd $deploy_path/$component; $deploy_path/helm/helm install kruise $deploy_file; "
}

batch_deploy

rm -f $deploy_file
