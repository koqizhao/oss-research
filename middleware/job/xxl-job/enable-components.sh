#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nxxl-job-admin\n"
    xxl-job-admin/start-service.sh $scale

    echo -e "\nxxl-job-executor\n"
    xxl-job-executor/start-service.sh $scale
}

do_stop()
{
    echo -e "\nxxl-job-executor\n"
    xxl-job-executor/stop-service.sh $scale

    echo -e "\nxxl-job-admin\n"
    xxl-job-admin/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nxxl-job-admin\n"
    xxl-job-admin/deploy-service.sh $scale

    echo -e "\nxxl-job-executor\n"
    xxl-job-executor/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nxxl-job-executor\n"
    xxl-job-executor/clean-service.sh $scale

    echo -e "\nxxl-job-admin\n"
    xxl-job-admin/clean-service.sh $scale

    clean_all ${servers[@]} ${executor_servers[@]}
}

do_status()
{
    echo -e "\nxxl-job-executor\n"
    xxl-job-executor/status-service.sh $scale

    echo -e "\nxxl-job-admin\n"
    xxl-job-admin/status-service.sh $scale
}

do_ops $1
