#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_version=7.9.3
deploy_file=filebeat-oss-$deploy_version-linux-x86_64.tar.gz
deploy_file_extracted=filebeat-$deploy_version-linux-x86_64

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/data/$component"

    scp ~/Software/elastic/${deploy_file} $server:$deploy_path
    scp filebeat.service $server:$deploy_path
    scp filebeat.yml $server:$deploy_path

    ssh $server "cd $deploy_path; tar xf $deploy_file; mv $deploy_file_extracted $component; mv filebeat.yml $component; rm $deploy_file"
    ssh $server "echo '$PASSWORD' | sudo -S chown root:root $deploy_path/$component/filebeat.yml"
    ssh $server "echo '$PASSWORD' | sudo -S chown root:root $deploy_path/filebeat.service"
    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/filebeat.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start filebeat.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable filebeat.service"
}

batch_deploy
