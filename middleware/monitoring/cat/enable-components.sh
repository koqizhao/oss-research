#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\ncat\n"
    cat/start-service.sh $scale
}

do_stop()
{
    echo -e "\ncat\n"
    cat/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\ncat\n"
    cat/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\ncat\n"
    cat/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\ncat\n"
    cat/status-service.sh $scale
}

do_ops $1
