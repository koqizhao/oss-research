#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

clean()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop grafana.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl disable grafana.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/grafana"
    ssh $server "echo '$PASSWORD' | sudo -S rm /etc/systemd/system/grafana.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
}

clean $1
