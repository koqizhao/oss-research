#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

read_server_pass

source common.sh

remote_clean()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y npm nodejs"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt autoremove -y --purge"

    ssh $1 "rm -rf ~/.npm"
    ssh $1 "rm -rf $deploy_path/$component"
}

batch_stop

batch_clean

sed "s/PG_USER/$pg_user/g" clean.sql \
    > clean.sql.tmp
pg_db_exec clean.sql.tmp
rm clean.sql.tmp
