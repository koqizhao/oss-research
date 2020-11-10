#!/bin/bash

deploy_path=/home/koqizhao/mysql
servers=(192.168.56.11)
mysql_password=xx123456XX

for server in ${servers[@]}
do
    echo -e "\nremote server: $server\n"
    ssh $server "cd $deploy_path; default/bin/mysqladmin --user=root --password='$mysql_password' shutdown"
    echo
    sleep 5
    ssh $server "ps aux | grep mysqld"
    echo
done
