#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nturbine\n"
    turbine/start-service.sh $scale

    echo -e "\nhystrix-dashboard\n"
    hystrix-dashboard/start-service.sh $scale
}

do_stop()
{
    echo -e "\nhystrix-dashboard\n"
    hystrix-dashboard/stop-service.sh $scale

    echo -e "\nturbine\n"
    turbine/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nturbine\n"
    turbine/deploy-service.sh $scale

    echo -e "\nhystrix-dashboard\n"
    hystrix-dashboard/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nhystrix-dashboard\n"
    hystrix-dashboard/clean-service.sh $scale

    echo -e "\nturbine\n"
    turbine/clean-service.sh $scale

    clean_all ${dashboard_servers[@]} ${turbine_servers[@]}
}

do_status()
{
    echo -e "\nhystrix-dashboard\n"
    hystrix-dashboard/status-service.sh $scale

    echo -e "\nturbine\n"
    turbine/status-service.sh $scale
}

do_ops $1
