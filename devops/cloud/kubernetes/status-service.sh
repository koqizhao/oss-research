#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

component=kubelet

batch_status

component=kubernetes

for s in ${master_servers[@]}
do
    echo -e "\nkube proxy: $s\n"
    ssh $s "ps aux | grep \"kubectl proxy\""
done

echo -e "\n\nadmin-user token\n"
ssh ${master_servers[0]} "kubectl -n kubernetes-dashboard describe secret \
    \$(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print \$1}')"

echo
