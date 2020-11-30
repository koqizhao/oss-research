#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

read_server_pass

source common.sh

remote_clean()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y kong"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt autoremove -y --purge"

    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf /etc/kong"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf /usr/local/kong"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf /usr/local/openresty"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
}

batch_stop

batch_clean

if [ $scale == "dist" ]; then
    sed "s/KONG_PG_USER/$kong_pg_user/g" clean.sql \
        > clean.sql.tmp
    pg_db_exec clean.sql.tmp
    rm clean.sql.tmp
fi
