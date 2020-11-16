#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .
read_server_pass

source common.sh

do_start()
{
    echo -e "\nconsul\n"
    consul/start-service.sh $scale
}

do_stop()
{
    echo -e "\nconsul\n"
    consul/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nconsul\n"
    consul/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nconsul\n"
    consul/clean-service.sh $scale

    clean_all ${consul_servers[@]}
}

do_status()
{
    echo -e "\nconsul\n"
    consul/status-service.sh $scale
}

do_ops $1
