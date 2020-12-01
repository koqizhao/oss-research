#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nopenresty\n"
    openresty/start-service.sh $scale
}

do_stop()
{
    echo -e "\nopenresty\n"
    openresty/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nopenresty\n"
    openresty/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nopenresty\n"
    openresty/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\nopenresty\n"
    openresty/status-service.sh $scale
}

do_ops $1
