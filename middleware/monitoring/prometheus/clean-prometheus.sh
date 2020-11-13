#!/bin/bash

echo -n "password: "
read -s PASSWORD

clean()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop prometheus.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl disable prometheus.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/prometheus"
    ssh $server "echo '$PASSWORD' | sudo -S rm /etc/systemd/system/prometheus.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
}

clean $1

echo
