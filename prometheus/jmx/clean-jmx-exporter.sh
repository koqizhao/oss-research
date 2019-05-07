#!/bin/bash

echo -n "password: "
read -s PASSWORD

clean()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop jmx-exporter.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl disable jmx-exporter.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/jmx-exporter"
    ssh $server "echo '$PASSWORD' | sudo -S rm /etc/systemd/system/jmx-exporter.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
}

clean $1
