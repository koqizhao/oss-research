#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nredis\n"
    redis/start-service.sh $scale

    echo -e "\nredis-cluster-proxy\n"
    redis-cluster-proxy/start-service.sh $scale
}

do_stop()
{
    echo -e "\nredis-cluster-proxy\n"
    redis-cluster-proxy/stop-service.sh $scale

    echo -e "\nredis\n"
    redis/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nredis\n"
    redis/deploy-service.sh $scale

    echo -e "\nredis-cluster-proxy\n"
    redis-cluster-proxy/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nredis-cluster-proxy\n"
    redis-cluster-proxy/clean-service.sh $scale

    echo -e "\nredis\n"
    redis/clean-service.sh $scale

    clean_all ${servers[@]} ${proxy_servers[@]}
}

do_status()
{
    echo -e "\nredis-cluster-proxy\n"
    redis-cluster-proxy/status-service.sh $scale

    echo -e "\nredis\n"
    redis/status-service.sh $scale
}

do_ops $1
