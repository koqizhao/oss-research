#!/bin/bash

deploy_path=/home/koqizhao/mysql/mysql
mysql_password=xx123456XX

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source servers.sh

echo -e "\nremote server: $server\n"
ssh $server "cd $deploy_path; bin/mysqladmin --user=root --password='$mysql_password' shutdown"
echo
sleep 5
ssh $server "ps aux | grep mysqld"
echo
