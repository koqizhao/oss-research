#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nkong\n"
    kong/start-service.sh $scale

    echo -e "\nkonga\n"
    konga/start-service.sh $scale
}

do_stop()
{
    echo -e "\nkonga\n"
    konga/stop-service.sh $scale

    echo -e "\nkong\n"
    kong/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nkong\n"
    kong/deploy-service.sh $scale

    echo -e "\nkonga\n"
    konga/start-service.sh $scale
}

do_clean()
{
    echo -e "\nkonga\n"
    konga/clean-service.sh $scale

    echo -e "\nkong\n"
    kong/clean-service.sh $scale

    clean_all ${servers[@]} ${konga_servers[@]}
}

do_status()
{
    echo -e "\nkonga\n"
    konga/status-service.sh $scale

    echo -e "\nkong\n"
    kong/status-service.sh $scale
}

do_ops $1
