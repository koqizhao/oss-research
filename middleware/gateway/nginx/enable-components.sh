#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nnginx\n"
    nginx/start-service.sh $scale
}

do_stop()
{
    echo -e "\nnginx\n"
    nginx/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nnginx\n"
    nginx/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nnginx\n"
    nginx/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\nnginx\n"
    nginx/status-service.sh $scale
}

do_ops $1
