#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

clean()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop elasticsearch.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl disable elasticsearch.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/elasticsearch"
    ssh $server "echo '$PASSWORD' | sudo -S rm /etc/systemd/system/elasticsearch.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
}

clean $1

echo
