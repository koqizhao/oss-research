#!/bin/bash

source ../common.sh

component=kubernetes
artifact=kubernetes-xenial

#mirror_site=https://apt.kubernetes.io
mirror_site=https://mirrors.aliyun.com/kubernetes/apt
apt_hash=836F4BEB
apt_hash2=307EA071

execute_ops()
{
    ssh $server "echo '$PASSWORD' | sudo -S bash -c 'cd $deploy_path/$component; source k8s-ops.sh; $@'"
}

enable_api_proxy()
{
#   ssh $1 "cd $deploy_path/$component; kubectl proxy --address=$1 --port=8001 \
#       --accept-hosts=192.168.56.1,192.168.56.10 > kube-proxy.log 2>&1 &"
    ssh $1 "cd $deploy_path/$component; kubectl proxy --address='0.0.0.0' --port=8001 \
        --accept-hosts='^*$' > kube-proxy.log 2>&1 &"
}
