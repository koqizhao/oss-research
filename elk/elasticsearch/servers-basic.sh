#!/bin/bash

declare -A servers_map
servers_map=([192.168.56.11]=server1 \
    [192.168.56.12]=server2)

servers_count=${#servers_map[@]}
seed_count=2
seed_hosts=""
initial_master_nodes=""
servers=()

c_r=1
for i in `seq $servers_count`
do
    k="192.168.56.1$i"
    v=${servers_map[$k]}
    if [ $c_r -le $seed_count ]; then
        if [ -z $seed_hosts ]; then
            seed_hosts="\"$k\""
            initial_master_nodes="\"$v\""
        else
            seed_hosts="$seed_hosts, \"$k\""
            initial_master_nodes="$initial_master_nodes, \"$v\""
        fi
        let "c_r+=1"
    fi

    let "ix=i-1"
    servers[$ix]=$k
done
