#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nshardingsphere-proxy\n"
    shardingsphere-proxy/start-service.sh $scale

    echo -e "\nshardingsphere-ui\n"
    shardingsphere-ui/start-service.sh $scale
}

do_stop()
{
    echo -e "\nshardingsphere-ui\n"
    shardingsphere-ui/stop-service.sh $scale

    echo -e "\nshardingsphere-proxy\n"
    shardingsphere-proxy/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nshardingsphere-proxy\n"
    shardingsphere-proxy/deploy-service.sh $scale

    echo -e "\nshardingsphere-ui\n"
    shardingsphere-ui/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nshardingsphere-ui\n"
    shardingsphere-ui/clean-service.sh $scale

    echo -e "\nshardingsphere-proxy\n"
    shardingsphere-proxy/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\nshardingsphere-ui\n"
    shardingsphere-ui/status-service.sh $scale

    echo -e "\nshardingsphere-proxy\n"
    shardingsphere-proxy/status-service.sh $scale
}

do_ops $1
