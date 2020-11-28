#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

read_server_pass

source common.sh

deploy_file=kong-2.2.0.focal.amd64.deb

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path/$component/conf"

    scp ~/Software/kong/$deploy_file $server:$deploy_path/$component
    ssh $server "cd $deploy_path/$component; \
        echo '$PASSWORD' | sudo -S apt install -y ./$deploy_file; \
        rm $deploy_file;"
    
    base_dir=`escape_slash $deploy_path/$component`
    sed "s/BASE_DIR/$base_dir/g" conf/kong.conf.$scale \
        > kong.conf.tmp
    scp kong.conf.tmp $server:$deploy_path/$component/conf/kong.conf
    rm kong.conf.tmp

    scp conf/kong.yml $server:$deploy_path/$component/conf

    remote_start $1 $2
}

batch_deploy
