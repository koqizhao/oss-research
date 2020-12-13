#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\ntinyid\n"
    tinyid/start-service.sh $scale
}

do_stop()
{
    echo -e "\ntinyid\n"
    tinyid/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\ntinyid\n"
    tinyid/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\ntinyid\n"
    tinyid/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\ntinyid\n"
    tinyid/status-service.sh $scale
}

do_ops $1
