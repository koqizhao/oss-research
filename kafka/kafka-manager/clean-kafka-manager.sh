#!/bin/bash

echo -n "password: "
read -s PASSWORD

server=$1

ssh $server "echo '$PASSWORD' | sudo -S systemctl stop kafka-manager.service"
ssh $server "echo '$PASSWORD' | sudo -S systemctl disable kafka-manager.service"
ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/kafka-manager"
ssh $server "echo '$PASSWORD' | sudo -S rm /etc/systemd/system/kafka-manager.service"
ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"

echo
