#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nlite-ui\n"
    lite-ui/start-service.sh $scale

    echo -e "\njob-executor\n"
    job-executor/start-service.sh $scale
}

do_stop()
{
    echo -e "\njob-executor\n"
    job-executor/stop-service.sh $scale

    echo -e "\nlite-ui\n"
    lite-ui/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nlite-ui\n"
    lite-ui/deploy-service.sh $scale

    echo -e "\njob-executor\n"
    job-executor/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\njob-executor\n"
    job-executor/clean-service.sh $scale

    echo -e "\nlite-ui\n"
    lite-ui/clean-service.sh $scale

    clean_all ${lite_ui_servers[@]} ${executor_servers[@]}
}

do_status()
{
    echo -e "\njob-executor\n"
    job-executor/status-service.sh $scale

    echo -e "\nlite-ui\n"
    lite-ui/status-service.sh $scale
}

do_ops $1
