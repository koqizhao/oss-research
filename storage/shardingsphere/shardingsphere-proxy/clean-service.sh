#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

clean_ds()
{
    mysql_db_exec data/clean.sql
}

remote_clean()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/logs/$component"
}

batch_stop

batch_clean

clean_ds
