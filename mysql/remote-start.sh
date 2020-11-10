#!/bin/bash

if [ -z "$PASSWORD" ]; then
    echo -n "password: "
    read -s PASSWORD
    echo
fi

deploy_path=/home/koqizhao/mysql
servers=(192.168.56.11)

for server in ${servers[@]}
do
    echo -e "\nremote server: $server\n"
    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S ./start-mysql.sh;"
    echo
    sleep 1
    ssh $server "ps aux | grep mysqld"
    echo
done
