#!/bin/bash

source ../common.sh

component=mysql

remote_start()
{
    server=$1
    ssh $server "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S ./start.sh;"
}

remote_stop()
{
    server=$1
    ssh $server "cd $deploy_path/$component; \
        bin/mysqladmin --user=root --password='$mysql_db_password' shutdown"
}
