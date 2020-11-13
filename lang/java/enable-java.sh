#!/bin/bash

set -e

echo -n "password: "
read -s PASSWORD

jdk=default-jdk

source ~/Research/servers.sh
for i in ${servers[@]}
do
    ssh $i "echo '$PASSWORD' | sudo -S apt install -y $jdk"
done

echo
