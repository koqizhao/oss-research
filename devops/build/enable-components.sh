#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\ngradle\n"
    gradle/start-service.sh $scale
}

do_stop()
{
    echo -e "\ngradle\n"
    gradle/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\ngradle\n"
    gradle/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\ngradle\n"
    gradle/clean-service.sh $scale
}

do_status()
{
    echo -e "\ngradle\n"
    gradle/status-service.sh $scale
}

do_ops $1
