#!/bin/bash

set -e

echo -n "password: "
read -s PASSWORD
echo

source ~/Research/servers.sh

for i in ${servers[@]}
do
    ssh $i "echo '$PASSWORD' | sudo -S rm -f /home/koqizhao/sources.list"
    scp ~/Research/sources.list $i:./
    ssh $i "echo '$PASSWORD' | sudo -S chown root:root /home/koqizhao/sources.list"
    ssh $i "echo '$PASSWORD' | sudo -S mv /home/koqizhao/sources.list /etc/apt/"
    ssh $i "echo '$PASSWORD' | sudo -S apt update"
    echo
done
