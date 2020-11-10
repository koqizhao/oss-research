#!/bin/bash

if [ -z "$PASSWORD" ]; then
    echo -n "password: "
    read -s PASSWORD
    echo
fi

deploy_path=/home/koqizhao/mysql/mysql

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source servers.sh

echo -e "\nremote server: $server\n"
ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S ./start-mysql.sh;"
echo
sleep 1
ssh $server "ps aux | grep mysqld"
echo
