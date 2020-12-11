#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nrabbitmq-server\n"
    rabbitmq-server/start-service.sh $scale
}

do_stop()
{
    echo -e "\nrabbitmq-server\n"
    rabbitmq-server/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nrabbitmq-server\n"
    rabbitmq-server/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nrabbitmq-server\n"
    rabbitmq-server/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\nrabbitmq-server\n"
    rabbitmq-server/status-service.sh $scale
}

do_ops $1
