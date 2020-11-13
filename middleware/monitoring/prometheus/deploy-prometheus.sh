#!/bin/bash

echo -n "password: "
read -s PASSWORD

deploy_file=prometheus-2.9.2.linux-amd64

deploy()
{
    server=$1

    echo -e "deploy server started: $server\n"

    ssh $server "mkdir -p ~/prometheus/data"

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop prometheus.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/prometheus/prometheus"

    scp ~/Software/prometheus/${deploy_file}.tar.gz $server:./prometheus/
    ssh $server "cd ~/prometheus; tar xf ${deploy_file}.tar.gz; mv $deploy_file prometheus; rm ${deploy_file}.tar.gz"
    scp prometheus.yml $server:./prometheus/prometheus/

    scp prometheus.service $server:./prometheus/
    ssh $server "echo '$PASSWORD' | sudo -S mv ~/prometheus/prometheus.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start prometheus.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable prometheus.service"

    echo -e "\ndeploy server finished: $server"
}

deploy $1
