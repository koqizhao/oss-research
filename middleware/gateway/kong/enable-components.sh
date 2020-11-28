#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nkong\n"
    kong/start-service.sh $scale
}

do_stop()
{
    echo -e "\nkong\n"
    kong/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nkong\n"
    kong/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nkong\n"
    kong/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\nkong\n"
    kong/status-service.sh $scale
}

do_ops $1
