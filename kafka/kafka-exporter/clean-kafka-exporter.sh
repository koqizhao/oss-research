#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

clean()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop kafka-exporter.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl disable kafka-exporter.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/kafka-exporter"
    ssh $server "echo '$PASSWORD' | sudo -S rm /etc/systemd/system/kafka-exporter.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
}

clean $1

echo
