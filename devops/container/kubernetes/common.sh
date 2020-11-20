#!/bin/bash

source ../common.sh

component=kubernetes
artifact=kubernetes-xenial

#mirror_site=https://apt.kubernetes.io
mirror_site=https://mirrors.aliyun.com/kubernetes/apt

execute_ops()
{
    ssh $server "echo '$PASSWORD' | sudo -S bash -c 'cd $deploy_path/$component; source k8s-ops.sh; $@'"
}
