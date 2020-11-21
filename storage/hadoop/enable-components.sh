#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nhadoop\n"
    hadoop/start-service.sh $scale
}

do_stop()
{
    echo -e "\nhadoop\n"
    hadoop/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nhadoop\n"
    hadoop/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nhadoop\n"
    hadoop/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\nhadoop\n"
    hadoop/status-service.sh $scale
}

do_ops $1
