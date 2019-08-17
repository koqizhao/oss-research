#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

clean()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop filebeat.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl disable filebeat.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/filebeat"
    ssh $server "echo '$PASSWORD' | sudo -S rm /etc/systemd/system/filebeat.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
}

clean $1

echo
