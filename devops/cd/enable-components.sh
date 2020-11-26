#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\njenkins\n"
    jenkins/start-service.sh $scale
}

do_stop()
{
    echo -e "\njenkins\n"
    jenkins/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\njenkins\n"
    jenkins/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\njenkins\n"
    jenkins/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\njenkins\n"
    jenkins/status-service.sh $scale
}

do_ops $1
