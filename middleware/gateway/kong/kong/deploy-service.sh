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
    if [ $scale == "basic" ]; then
        sed "s/BASE_DIR/$base_dir/g" conf/kong.conf.$scale \
            > kong.conf.tmp
    else
        sed "s/BASE_DIR/$base_dir/g" conf/kong.conf.$scale \
            | sed "s/PG_HOST/$pg_db_server/g" \
            | sed "s/KONG_PG_USER/$kong_pg_user/g" \
            | sed "s/KONG_PG_PASSWORD/$kong_pg_password/g" \
            > kong.conf.tmp
    fi
    scp kong.conf.tmp $server:$deploy_path/$component/conf/kong.conf
    rm kong.conf.tmp

    scp conf/kong.yml $server:$deploy_path/$component/conf
}

batch_deploy

if [ $scale == "dist" ]; then
    sed "s/KONG_PG_USER/$kong_pg_user/g" init.sql \
        | sed "s/KONG_PG_PASSWORD/$kong_pg_password/g" \
        > init.sql.tmp
    pg_db_exec init.sql.tmp
    rm init.sql.tmp

    ssh ${servers[0]} "cd $deploy_path/$component; \
        kong migrations bootstrap -c conf/kong.conf; "
fi

batch_start
