#!/bin/bash

echo -n "password: "
read -s PASSWORD

server=$1
zk_connect=192.168.56.11:2181

deploy_file=kafka-manager-2.0.0.2

echo -e "deploy server started: $server\n"

ssh $server "echo '$PASSWORD' | sudo -S systemctl stop kafka-manager.service"
ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/kafka-manager"

scp ~/Software/kafka/${deploy_file}.tar.gz $server:./
ssh $server "tar xf ${deploy_file}.tar.gz; mv $deploy_file kafka-manager; rm ${deploy_file}.tar.gz"

scp kafka-manager.service $server:./kafka-manager/
sed "s/ZOOKEEPER_CONNECT/$zk_connect/g" application.conf > temp.conf
scp temp.conf $server:./kafka-manager/conf/application.conf
rm temp.conf

ssh $server "echo '$PASSWORD' | sudo -S mv ~/kafka-manager/kafka-manager.service /etc/systemd/system/"
ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
ssh $server "echo '$PASSWORD' | sudo -S systemctl start kafka-manager.service"
ssh $server "echo '$PASSWORD' | sudo -S systemctl enable kafka-manager.service"

echo -e "\ndeploy server finished: $server"
