#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

clean()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop kibana.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl disable kibana.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/kibana"
    ssh $server "echo '$PASSWORD' | sudo -S rm /etc/systemd/system/kibana.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
}

clean $1

echo
