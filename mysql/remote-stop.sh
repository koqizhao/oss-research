#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" .

source common.sh

stop()
{
    server=$1
    ssh $server "cd $deploy_path/$component; bin/mysqladmin --user=root --password='$db_password' shutdown"
}

remote_stop
