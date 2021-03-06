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
    ssh $server "mkdir -p $deploy_path/logs/$component"

    scp ~/Software/elastic/${deploy_file} $server:$deploy_path

    data_dir=`escape_slash $deploy_path/data/$component`
    log_dir=`escape_slash $deploy_path/logs/$component`
    sed "s/DATA_DIR/$data_dir/g" $component.yml \
        | sed "s/LOG_DIR/$log_dir/g" \
        > $component.yml.tmp
    scp $component.yml.tmp $server:$deploy_path/$component.yml
    rm $component.yml.tmp

    base_dir=`escape_slash $deploy_path/$component`
    sed "s/BASE_DIR/$base_dir/g" $component.service \
        > $component.service.tmp 
    scp $component.service.tmp $server:$deploy_path/$component.service
    rm $component.service.tmp

    ssh $server "cd $deploy_path; tar xf $deploy_file; mv $deploy_file_extracted $component; mv filebeat.yml $component; rm $deploy_file"
    ssh $server "echo '$PASSWORD' | sudo -S chown root:root $deploy_path/$component/filebeat.yml"
    ssh $server "echo '$PASSWORD' | sudo -S chown root:root $deploy_path/filebeat.service"
    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/filebeat.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start filebeat.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable filebeat.service"
}

batch_deploy
