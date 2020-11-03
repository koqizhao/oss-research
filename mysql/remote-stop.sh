#!/bin/bash

echo -n "mysql password: "
read -s PASSWORD
echo

deploy_path=/home/koqizhao/mysql
servers=(192.168.56.11)

for server in ${servers[@]}
do
    echo "remote server: $server"
    ssh $server "cd $deploy_path; default/bin/mysqladmin --user=root --password='$PASSWORD' shutdown"
    echo
    sleep 1
    ssh $server "ps aux | grep mysql"
    echo
done
