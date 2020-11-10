#!/bin/bash

if [ -z "$PASSWORD" ]; then
    echo -n "password: "
    read -s PASSWORD
    echo
fi

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path

deploy_path=/home/koqizhao/mysql
mysql_password=xx123456XX

source servers.sh

echo -e "\nclean started: $server\n"
ssh $server "cd $deploy_path/mysql; bin/mysqladmin --user=root --password='$mysql_password' shutdown && sleep 5"
echo

ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path"
ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/profile.d/mysql.sh"
ssh $server "echo '$PASSWORD' | sudo -S userdel -f mysql"

echo -e "\nclean finished: $server\n"
