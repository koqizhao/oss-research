#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo '$PASSWORD'
echo

deploy()
{
    server=$1
    id=$2

    echo -e "deploy server started: $server\n"

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop kafka.service"
    ssh $server "mkdir -p ~/kafka"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/kafka/kafka"
    ssh $server "echo '$PASSWORD' | sudo -S mkdir -p /opt/settings"

    scp -r kafka $server:./kafka/
    scp -r ctrip-cp $server:./kafka/kafka/
    scp -r ctrip-libs $server:./kafka/kafka/
    scp config/server-$id.properties $server:./kafka/kafka/config/server.properties
    scp config/log4j.properties $server:./kafka/kafka/config/log4j.properties
    scp config/kafka-env-$id.sh $server:./kafka/kafka/kafka-env.sh
    scp kafka.sh $server:./kafka/kafka/
    scp kafka.service $server:./kafka/kafka/
    scp server.properties $server:./kafka/kafka/

    ssh $server "echo '$PASSWORD' | sudo -S mv ~/kafka/kafka/kafka.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S mv ~/kafka/kafka/server.properties /opt/settings/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start kafka.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable kafka.service"

    echo -e "\ndeploy server finished: $server"
}

source ~/Research/servers.sh

for i in `seq 0 2`
do
    deploy ${servers[$i]} $i
done

