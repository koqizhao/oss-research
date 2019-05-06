#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo '$PASSWORD'
echo

machine_count=1

if [ -n "$1" ]
then
    machine_count=$1
fi

kafka_file=kafka_2.12-2.2.0
zk_connect=192.168.56.11:2181

deploy()
{
    server=$1
    id=$2

    echo -e "deploy server started: $server\n"

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop kafka.service"
    ssh $server "mkdir -p ~/kafka"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/kafka/kafka"

    scp ~/Software/kafka/${kafka_file}.tgz $server:./kafka/
    ssh $server "cd ~/kafka/; tar xf ${kafka_file}.tgz; mv $kafka_file kafka; rm ${kafka_file}.tgz"

    sed "s/BROKER_ID/$id/g" config/server.properties | sed "s/HOST_IP/$server/g" | sed "s/ZOOKEEPER_CONNECT/$zk_connect/g" > server.properties
    scp server.properties $server:./kafka/kafka/config/server.properties
    rm server.properties

    #scp config/log4j.properties $server:./kafka/kafka/config/log4j.properties

    scp config/kafka-env.sh $server:./kafka/kafka/kafka-env.sh
    scp kafka.sh $server:./kafka/kafka/
    scp kafka.service $server:./kafka/kafka/

    ssh $server "echo '$PASSWORD' | sudo -S mv ~/kafka/kafka/kafka.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start kafka.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable kafka.service"

    echo -e "\ndeploy server finished: $server"
}

source ~/Research/servers.sh

#for i in `let count=${#servers[@]}-1; seq 0 $count`
for i in `let machine_count=machine_count-1; seq 0 $machine_count`
do
    deploy ${servers[$i]} $i
done
