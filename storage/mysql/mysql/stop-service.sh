#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_stop()
{
    server=$1
    ssh $server "cd $deploy_path/$component; \
        bin/mysqladmin --user=root --password='$mysql_db_password' shutdown"
}

batch_stop
