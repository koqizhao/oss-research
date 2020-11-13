#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_version=7.9.3
deploy_file=kibana-oss-$deploy_version-linux-x86_64.tar.gz
deploy_file_extracted=kibana-$deploy_version-linux-x86_64

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/data/$component"

    scp ~/Software/elastic/${deploy_file} $server:$deploy_path
    scp kibana.service $server:$deploy_path
    scp kibana.yml $server:$deploy_path

    ssh $server "cd $deploy_path; tar xf $deploy_file; mv $deploy_file_extracted $component; mv kibana.yml $component/config/; rm $deploy_file"
    ssh $server "echo '$PASSWORD' | sudo -S chown root:root $deploy_path/kibana.service"
    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/kibana.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start kibana.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable kibana.service"
}

batch_deploy
