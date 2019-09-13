#!/bin/bash

echo -n "password: "
read -s PASSWORD

name_node=192.168.56.12
nodes=(192.168.56.12 192.168.56.13 192.168.56.15)

ssh $name_node "~/hadoop/hadoop/sbin/stop-dfs.sh"

for node in ${nodes[@]}
do
    ssh $node "echo '$PASSWORD' | sudo -S rm -rf ~/hadoop/hadoop"
    echo
    ssh $node "echo '$PASSWORD' | sudo -S rm -rf ~/hadoop/logs"
    echo
    ssh $node "echo '$PASSWORD' | sudo -S rm -rf ~/hadoop/data"
    echo
    ssh $node "echo '$PASSWORD' | sudo -S rm -rf ~/hadoop/name"
    echo
    ssh $node "echo '$PASSWORD' | sudo -S rm -rf ~/hadoop/tmp"
    echo
done

echo
