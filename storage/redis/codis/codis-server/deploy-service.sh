#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_deploy()
{
    server=$1
    component=$2

    remote_deploy_file $server $component

    ssh $server "mkdir -p $deploy_path/data/$component"
    ssh $server "touch $deploy_path/logs/$component/$component.log; \
        chmod a+w $deploy_path/logs/$component/$component.log; "

    data_dir=`escape_slash $deploy_path/data/$component`
    log_dir=`escape_slash $deploy_path/logs/$component`
    base_dir=`escape_slash $deploy_path/$component`

    sed "s/SERVER_IP/$server/g" conf/redis.conf \
        | sed "s/DATA_DIR/$data_dir/g" \
        | sed "s/LOG_DIR/$log_dir/g" \
        > conf/redis.conf.tmp
    scp conf/redis.conf.tmp $server:$deploy_path/$component/conf/redis.conf
    rm conf/redis.conf.tmp

    sed "s/BASE_DIR/$base_dir/g" $component.service \
        | sed "s/LOG_DIR/$log_dir/g" \
        > $component.service.tmp
    scp $component.service.tmp $server:$deploy_path/$component.service
    rm $component.service.tmp

    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/$component.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S chown root:root /etc/systemd/system/$component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start $component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable $component.service"

}

batch_deploy
