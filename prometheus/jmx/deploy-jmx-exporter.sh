#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo '$PASSWORD'
echo

deploy()
{
    server=$1

    echo -e "deploy server started: $server\n"

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop jmx-exporter.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/kafka/jmx-exporter"
    ssh $server "mkdir -p ~/kafka/jmx-exporter"

    scp jmx_exporter.jar $server:./kafka/jmx-exporter/
    scp kafka.yml $server:./kafka/jmx-exporter/
    scp start.sh $server:./kafka/jmx-exporter/
    scp stop.sh $server:./kafka/jmx-exporter/
    scp jmx-exporter.service $server:./kafka/jmx-exporter/

    ssh $server "echo '$PASSWORD' | sudo -S mv ~/kafka/jmx-exporter/jmx-exporter.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start jmx-exporter.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable jmx-exporter.service"

    echo -e "\ndeploy server finished: $server"
}

deploy $1

