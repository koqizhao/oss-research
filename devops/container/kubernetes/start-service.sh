#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

component=kubelet

batch_start

component=kubernetes

for s in ${master_servers[@]}
do
    echo -e "\nkube proxy: $s\n"
    enable_api_proxy $s
done

echo
