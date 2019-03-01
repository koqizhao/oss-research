#!/bin/bash

echo -n "password: "
read -s PASSWORD

server=$1

echo -e "deploy server started: $server\n"

ssh $server "echo '$PASSWORD' | sudo -S systemctl stop kafka-manager.service"
ssh $server "mkdir -p ~/kafka"
ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/kafka/kafka-manager"

scp -r kafka-manager $server:./kafka/
scp kafka-manager.service $server:./kafka/kafka-manager/
scp application.conf $server:./kafka/kafka-manager/conf/

ssh $server "echo '$PASSWORD' | sudo -S mv ~/kafka/kafka-manager/kafka-manager.service /etc/systemd/system/"
ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
ssh $server "echo '$PASSWORD' | sudo -S systemctl start kafka-manager.service"
ssh $server "echo '$PASSWORD' | sudo -S systemctl enable kafka-manager.service"

echo -e "\ndeploy server finished: $server"

