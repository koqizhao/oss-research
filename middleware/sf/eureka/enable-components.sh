#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\neureka\n"
    eureka/start-service.sh $scale
}

do_stop()
{
    echo -e "\neureka\n"
    eureka/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\neureka\n"
    eureka/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\neureka\n"
    eureka/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\neureka\n"
    eureka/status-service.sh $scale
}

do_ops $1
