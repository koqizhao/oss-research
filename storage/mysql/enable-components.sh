#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nmysql\n"
    mysql/start-service.sh $scale

    echo -e "\nmysql-workbench\n"
    mysql-workbench/start-service.sh $scale
}

do_stop()
{
    echo -e "\nmysql-workbench\n"
    mysql-workbench/stop-service.sh $scale

    echo -e "\nmysql\n"
    mysql/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nmysql\n"
    mysql/deploy-service.sh $scale

    echo -e "\nmysql-workbench\n"
    mysql-workbench/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nmysql-workbench\n"
    mysql-workbench/clean-service.sh $scale

    echo -e "\nmysql\n"
    mysql/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\nmysql-workbench\n"
    mysql-workbench/status-service.sh $scale

    echo -e "\nmysql\n"
    mysql/status-service.sh $scale
}

do_ops $1
