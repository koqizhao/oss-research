#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

deploy_file=kafka_exporter-1.2.0.linux-amd64

deploy()
{
    server=$1

    echo -e "deploy server started: $server\n"

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop kafka-exporter.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/kafka-exporter"

    scp ~/Software/kafka/${deploy_file}.tar.gz $server:./
    ssh $server "tar xf ${deploy_file}.tar.gz; mv $deploy_file kafka-exporter; rm ${deploy_file}.tar.gz"

    scp stop.sh $server:./kafka-exporter/
    scp kafka-exporter.service $server:./kafka-exporter/

    sed "s/KAFKA_SERVER/$server/g" start.sh > temp.sh
    scp temp.sh $server:./kafka-exporter/start.sh
    ssh $server "chmod +x ~/kafka-exporter/start.sh"
    rm temp.sh

    ssh $server "echo '$PASSWORD' | sudo -S mv ~/kafka-exporter/kafka-exporter.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start kafka-exporter.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable kafka-exporter.service"

    echo -e "\ndeploy server finished: $server"
}

deploy $1
