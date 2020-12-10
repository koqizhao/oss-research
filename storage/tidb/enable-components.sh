#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\ntidb\n"
    tidb/start-service.sh $scale
}

do_stop()
{
    echo -e "\ntidb\n"
    tidb/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\ntidb\n"
    tidb/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\ntidb\n"
    tidb/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\ntidb\n"
    tidb/status-service.sh $scale
}

do_ops $1
