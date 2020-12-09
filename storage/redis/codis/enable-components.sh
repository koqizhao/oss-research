#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\ncodis-dashboard\n"
    codis-dashboard/start-service.sh $scale

    echo -e "\ncodis-proxy\n"
    codis-proxy/start-service.sh $scale

    echo -e "\ncodis-server\n"
    codis-server/start-service.sh $scale

    echo -e "\ncodis-fe\n"
    codis-fe/start-service.sh $scale
}

do_stop()
{
    echo -e "\ncodis-fe\n"
    codis-fe/stop-service.sh $scale

    echo -e "\ncodis-server\n"
    codis-server/stop-service.sh $scale

    echo -e "\ncodis-proxy\n"
    codis-proxy/stop-service.sh $scale

    echo -e "\ncodis-dashboard\n"
    codis-dashboard/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\ncodis-dashboard\n"
    codis-dashboard/deploy-service.sh $scale

    echo -e "\ncodis-proxy\n"
    codis-proxy/deploy-service.sh $scale

    echo -e "\ncodis-server\n"
    codis-server/deploy-service.sh $scale

    echo -e "\ncodis-fe\n"
    codis-fe/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\ncodis-fe\n"
    codis-fe/clean-service.sh $scale

    echo -e "\ncodis-server\n"
    codis-server/clean-service.sh $scale

    echo -e "\ncodis-proxy\n"
    codis-proxy/clean-service.sh $scale

    echo -e "\ncodis-dashboard\n"
    codis-dashboard/clean-service.sh $scale

    clean_all ${servers[@]} ${dashboard_servers[@]} ${proxy_servers[@]} ${fe_servers[@]}
}

do_status()
{
    echo -e "\ncodis-fe\n"
    codis-fe/status-service.sh $scale

    echo -e "\ncodis-server\n"
    codis-server/status-service.sh $scale

    echo -e "\ncodis-proxy\n"
    codis-proxy/status-service.sh $scale

    echo -e "\ncodis-dashboard\n"
    codis-dashboard/status-service.sh $scale
}

do_ops $1
