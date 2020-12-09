#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=grafana-7.3.2

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/data/$component; mkdir -p $deploy_path/logs/$component;"
    ssh $server "touch $deploy_path/logs/$component/$component.log; \
        chmod a+w $deploy_path/logs/$component/$component.log"

    scp ~/Software/metric/${deploy_file}.linux-amd64.tar.gz $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf ${deploy_file}.linux-amd64.tar.gz; mv $deploy_file $component; rm ${deploy_file}.linux-amd64.tar.gz"

    base_dir=`escape_slash $deploy_path/$component`
    data_dir=`escape_slash $deploy_path/data/$component`
    log_dir=`escape_slash $deploy_path/logs/$component`

    sed "s/BASE_DIR/$base_dir/g" custom.ini \
        | sed "s/DATA_DIR/$data_dir/g" \
        | sed "s/LOG_DIR/$log_dir/g" \
        > custom.ini.tmp 
    scp custom.ini.tmp $server:$deploy_path/$component/conf/custom.ini
    rm custom.ini.tmp

    scp start.sh $server:$deploy_path/$component

    sed "s/BASE_DIR/$base_dir/g" $component.service \
        | sed "s/LOG_DIR/$log_dir/g" \
        > $component.service.tmp 
    scp $component.service.tmp $server:$deploy_path/$component.service
    rm $component.service.tmp

    ssh $server "echo '$PASSWORD' | sudo -S chown root:root $deploy_path/$component.service"
    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/$component.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start $component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable $component.service"
}

batch_deploy
