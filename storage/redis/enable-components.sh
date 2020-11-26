#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nredis\n"
    redis/start-service.sh $scale
}

do_stop()
{
    echo -e "\nredis\n"
    redis/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nredis\n"
    redis/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nredis\n"
    redis/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\nredis\n"
    redis/status-service.sh $scale
}

do_ops $1
