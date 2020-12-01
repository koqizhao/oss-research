#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\napisix\n"
    apisix/start-service.sh $scale
}

do_stop()
{
    echo -e "\napisix\n"
    apisix/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\napisix\n"
    apisix/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\napisix\n"
    apisix/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\napisix\n"
    apisix/status-service.sh $scale
}

do_ops $1
