#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nnacos\n"
    nacos/start-service.sh $scale
}

do_stop()
{
    echo -e "\nnacos\n"
    nacos/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nnacos\n"
    nacos/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nnacos\n"
    nacos/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\nnacos\n"
    nacos/status-service.sh $scale
}

do_ops $1
