#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file_name=rocketmq-all-4.7.1-bin-release
deploy_file=$deploy_file_name.zip

namesrv_addr=""
for s in ${name_servers[@]}
do
    if [ -z "$namesrv_addr" ]; then
        namesrv_addr="$s:9876"
    else
        namesrv_addr="$namesrv_addr;$s:9876"
    fi
done

remote_deploy()
{
    server=$1
    role=$2

    ssh $server "echo '$PASSWORD' | sudo -S apt install -y unzip openjdk-8-jdk"

    ssh $server "mkdir -p $deploy_path/$component"
    ssh $server "mkdir -p $deploy_path/logs/$component/$role"
    ssh $server "mkdir -p $deploy_path/data/$component/$role"

    scp ~/Software/rocketmq/$deploy_file $server:$deploy_path/$component
    ssh $server "cd $deploy_path/$component; unzip $deploy_file; mv $deploy_file_name $role; rm $deploy_file; "

    scp bin/* $server:$deploy_path/$component/$role/bin

    log_dir=`escape_slash $deploy_path/logs/$component/$role`
    log_files=(`ls conf/*.xml`)
    for f in ${log_files[@]}
    do
        f_n=`basename $f`
        sed "s/LOG_DIR/$log_dir/g" conf/$f_n \
            > conf/$f_n.tmp
        scp conf/$f_n.tmp $server:$deploy_path/$component/$role/conf/$f_n
        rm conf/$f_n.tmp
    done
}

deploy_start_script()
{
    server=$1
    role=$2
    script=$3

    log_dir=`escape_slash $deploy_path/logs/$component/$role`
    sed "s/LOG_DIR/$log_dir/g" $script \
        > $script.tmp
    chmod a+x $script.tmp
    scp $script.tmp $server:$deploy_path/$component/$role/$script
    rm $script.tmp
}

deploy_namesrv()
{
    remote_deploy $1 $2
    scp conf/namesrv.properties $1:$deploy_path/$component/$2/conf
    deploy_start_script $1 $2 $3
}

deploy_name_servers()
{
    for s in ${name_servers[@]}
    do
        deploy_namesrv $s namesrv start-namesrv.sh
    done
}

deploy_broker()
{
    server=$1
    role=$2
    script=$3

    remote_deploy $server $role

    data_dir=`escape_slash $deploy_path/data/$component/$role`
    sed "s/DATA_DIR/$data_dir/g" conf/brokers/$role.properties \
        | sed "s/NS_ADDRESS/$namesrv_addr/g" \
        | sed "s/SERVER_IP/$server/g" \
        > conf/brokers/$role.properties.tmp
    scp conf/brokers/$role.properties.tmp $server:$deploy_path/$component/$role/conf/broker.conf
    rm conf/brokers/$role.properties.tmp

    deploy_start_script $server $role $script
}

deploy_brokers()
{
    for role in ${!broker_role_server_map[@]}
    do
        deploy_broker ${broker_role_server_map[$role]} $role start-broker.sh
    done
}

deploy_name_servers

deploy_brokers

batch_start
