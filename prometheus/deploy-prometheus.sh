#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo '$PASSWORD'
echo

deploy()
{
    server=$1

    echo -e "deploy server started: $server\n"

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop prometheus.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/prometheus/prometheus"
    ssh $server "mkdir -p ~/prometheus"

    scp -r prometheus $server:./prometheus/
    scp prometheus.service $server:./prometheus/prometheus/
    scp prometheus.yml $server:./prometheus/prometheus/
    ssh $server "mkdir -p ~/prometheus/prometheus/data"

    ssh $server "echo '$PASSWORD' | sudo -S mv ~/prometheus/prometheus/prometheus.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start prometheus.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable prometheus.service"

    echo -e "\ndeploy server finished: $server"
}

deploy $1

