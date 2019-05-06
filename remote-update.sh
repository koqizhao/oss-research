#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

source ~/Research/servers.sh

for i in ${servers[@]}
do
    ssh $i "echo '$PASSWORD' | sudo -S apt update"
    ssh $i "echo '$PASSWORD' | sudo -S apt autoremove --purge -y"
    ssh $i "echo '$PASSWORD' | sudo -S apt upgrade -y"
    ssh $i "echo '$PASSWORD' | sudo -S reboot"
    echo
done

