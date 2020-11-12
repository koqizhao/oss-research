#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" .

source common.sh

remote_clean()
{
    server=$1
    ssh $server "cd $deploy_path/$component; bin/mysqladmin --user=root --password='$db_password' shutdown && sleep 5"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/data"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/profile.d/mysql.sh"
    ssh $server "echo '$PASSWORD' | sudo -S userdel -f mysql"
}

batch_clean
