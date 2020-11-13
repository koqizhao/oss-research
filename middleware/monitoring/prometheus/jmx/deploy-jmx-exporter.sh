#!/bin/bash

echo -n "password: "
read -s PASSWORD

deploy_file=jmx_prometheus_httpserver-0.11.1-SNAPSHOT-jar-with-dependencies.jar

deploy()
{
    server=$1

    echo -e "deploy server started: $server\n"

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop jmx-exporter.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/jmx-exporter"

    ssh $server "mkdir -p ~/jmx-exporter"

    scp ~/Software/kafka/$deploy_file $server:./jmx-exporter/jmx_exporter.jar
    scp kafka.yml $server:./jmx-exporter/
    scp start.sh $server:./jmx-exporter/
    scp stop.sh $server:./jmx-exporter/
    scp jmx-exporter.service $server:./jmx-exporter/

    ssh $server "echo '$PASSWORD' | sudo -S mv ~/jmx-exporter/jmx-exporter.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start jmx-exporter.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable jmx-exporter.service"

    echo -e "\ndeploy server finished: $server"
}

deploy $1
