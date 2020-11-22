#!/bin/bash

set -e

echo -n "password: "
read -s PASSWORD

jdk=openjdk-8-jdk

source ~/Research/lab/env/servers.sh
for i in ${servers[@]}
do
    ssh $i "echo '$PASSWORD' | sudo -S apt install -y $jdk"
done

echo
