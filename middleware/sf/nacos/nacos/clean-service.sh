#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

clean_db()
{
    mysql_db_exec conf/clean.sql
}

remote_clean()
{
    server=$1

    ssh $server "rm -rf $deploy_path/$component"
}

batch_stop

batch_clean

if [ $scale == "dist" ]; then
    clean_db
fi
