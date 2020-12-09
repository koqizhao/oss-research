#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_deploy()
{
    server=$1
    component=$2

    remote_deploy_file $server $component

    sed "s/COORDINATOR_NAME/$coordinator_name/g" conf/$component.toml \
        | sed "s/COORDINATOR_ADDR/$coordinator_addr/g" \
        > conf/$component.toml.tmp
    scp conf/$component.toml.tmp $server:$deploy_path/$component/conf/$component.toml
    rm conf/$component.toml.tmp

    log_dir=`escape_slash $deploy_path/logs/$component`
    sed "s/LOG_DIR/$log_dir/g" start-$component.sh \
        > start-$component.sh.tmp
    chmod a+x start-$component.sh.tmp
    scp start-$component.sh.tmp $server:$deploy_path/$component/start-$component.sh
    rm start-$component.sh.tmp
}

batch_deploy

batch_start
