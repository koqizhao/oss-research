#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nmongodb\n"
    mongodb/start-service.sh $scale

    echo -e "\ncompass\n"
    compass/start-service.sh $scale
}

do_stop()
{
    echo -e "\ncompass\n"
    compass/stop-service.sh $scale

    echo -e "\nmongodb\n"
    mongodb/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nmongodb\n"
    mongodb/deploy-service.sh $scale

    echo -e "\ncompass\n"
    compass/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\ncompass\n"
    compass/clean-service.sh $scale

    echo -e "\nmongodb\n"
    mongodb/clean-service.sh $scale

    clean_all ${servers[@]} ${compass_servers[@]}
}

do_status()
{
    echo -e "\ncompass\n"
    compass/status-service.sh $scale

    echo -e "\nmongodb\n"
    mongodb/status-service.sh $scale
}

do_ops $1
