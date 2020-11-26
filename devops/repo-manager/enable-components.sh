#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nnexus\n"
    nexus/start-service.sh $scale
}

do_stop()
{
    echo -e "\nnexus\n"
    nexus/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nnexus\n"
    nexus/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nnexus\n"
    nexus/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\nnexus\n"
    nexus/status-service.sh $scale
}

do_ops $1
