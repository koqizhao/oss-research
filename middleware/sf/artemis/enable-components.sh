#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .
read_server_pass

source common.sh

do_start()
{
    echo -e "\nartemis\n"
    artemis/start-service.sh $scale
}

do_stop()
{
    echo -e "\nartemis\n"
    artemis/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nartemis\n"
    artemis/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nartemis\n"
    artemis/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\nartemis\n"
    artemis/status-service.sh $scale
}

do_ops $1
