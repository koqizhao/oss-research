#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

clean_db()
{
    mysql_db_exec clean.sql
}

remote_clean()
{
    server=$1

    ssh $server "rm -rf $deploy_path/$component"
    ssh $server "rm -rf $deploy_path/logs/$component"
}

batch_stop

batch_clean

clean_db
