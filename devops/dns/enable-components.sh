#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nbind9\n"
    bind9/start-service.sh $scale
}

do_stop()
{
    echo -e "\nbind9\n"
    bind9/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nbind9\n"
    bind9/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nbind9\n"
    bind9/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\nbind9\n"
    bind9/status-service.sh $scale
}

do_ops $1
