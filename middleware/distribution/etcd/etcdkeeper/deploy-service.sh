#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=etcdkeeper-v0.7.6-linux_x86_64.zip

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/logs/$component; \
        touch $deploy_path/logs/$component/$component.log; \
        chmod a+w $deploy_path/logs/$component/$component.log"

    scp ~/Software/etcd/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; \
        unzip $deploy_file; rm $deploy_file; chmod a+x $component/etcdkeeper; "

    scp start.sh $server:$deploy_path/$component

    base_dir=`escape_slash $deploy_path/$component`
    log_dir=`escape_slash $deploy_path/logs/$component`
    sed "s/BASE_DIR/$base_dir/g" $component.service \
        | sed "s/LOG_DIR/$log_dir/g" \
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
