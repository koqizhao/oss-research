#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nleaf\n"
    leaf/start-service.sh $scale
}

do_stop()
{
    echo -e "\nleaf\n"
    leaf/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nleaf\n"
    leaf/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nleaf\n"
    leaf/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\nleaf\n"
    leaf/status-service.sh $scale
}

do_ops $1
