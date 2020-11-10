#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source servers.sh

clean()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop filebeat.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl disable filebeat.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm /etc/systemd/system/filebeat.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/filebeat"
}

for server in ${servers[@]}
do
    echo "remote server: $server"
    clean $server
    echo
done