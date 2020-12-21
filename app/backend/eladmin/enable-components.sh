#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .
read_server_pass

source common.sh

do_start()
{
    echo -e "\neladmin\n"
    eladmin/start-service.sh $scale
}

do_stop()
{
    echo -e "\neladmin\n"
    eladmin/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\neladmin\n"
    eladmin/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\neladmin\n"
    eladmin/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\neladmin\n"
    eladmin/status-service.sh $scale
}

do_ops $1
