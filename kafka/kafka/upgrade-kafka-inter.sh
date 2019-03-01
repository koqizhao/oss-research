#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

upgrade()
{
    server=$1
    id=$2

    echo -e "upgrade server started: $server\n"

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop kafka.service"

    scp config-upgrade-inter/server-$id.properties $server:./kafka/kafka/config/server.properties

    ssh $server "echo '$PASSWORD' | sudo -S systemctl start kafka.service"

    echo -e "\nupgrade server finished: $server"
}

upgrade $1 $2

