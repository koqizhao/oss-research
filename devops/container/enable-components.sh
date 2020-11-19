#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\ndocker\n"
    docker/start-service.sh $scale

    echo -e "\nkubernetes\n"
    kubernetes/start-service.sh $scale
}

do_stop()
{
    echo -e "\nkubernetes\n"
    kubernetes/stop-service.sh $scale

    echo -e "\ndocker\n"
    docker/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\ndocker\n"
    docker/deploy-service.sh $scale

    echo -e "\nkubernetes\n"
    kubernetes/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nkubernetes\n"
    kubernetes/clean-service.sh $scale

    echo -e "\ndocker\n"
    docker/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\nkubernetes\n"
    kubernetes/status-service.sh $scale

    echo -e "\ndocker\n"
    docker/status-service.sh $scale
}

do_ops $1
