#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

deploy_file=grafana-5.2.4.linux-amd64.tar.gz

deploy()
{
    server=$1

    echo -e "deploy server started: $server\n"

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop grafana.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/grafana/grafana"
    ssh $server "mkdir -p ~/grafana"

    scp $deploy_file $server:./grafana/
    scp grafana.service $server:./grafana/
    scp custom.ini $server:./grafana/

    ssh $server "cd ~/grafana; tar xf $deploy_file; mv grafana-5.2.4 grafana; mv custom.ini grafana/conf; rm $deploy_file"
    ssh $server "echo '$PASSWORD' | sudo -S mv ~/grafana/grafana.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start grafana.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable grafana.service"

    echo -e "\ndeploy server finished: $server"
}

deploy $1

