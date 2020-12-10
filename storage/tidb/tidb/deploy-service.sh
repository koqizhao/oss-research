#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/$component"
    ssh $server "mkdir -p $deploy_path/logs/$component"

    ssh $server "cd $deploy_path/$component; \
        curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh | sh ;
        tiup cluster; "

    declare base_dir=`escape_slash $deploy_path/$component`
    declare log_dir=`escape_slash $deploy_path/logs/$component`
    sed "s/BASE_DIR/$base_dir/g" start.sh.$scale \
        | sed "s/LOG_DIR/$log_dir/g" \
        | sed "s/HOST/$server/g" \
        > start.sh.tmp
    chmod a+x start.sh.tmp
    scp start.sh.tmp $server:$deploy_path/$component/start.sh
    rm start.sh.tmp
}

batch_deploy

batch_start
