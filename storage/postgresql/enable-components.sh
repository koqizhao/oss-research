#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\npostgresql\n"
    postgresql/start-service.sh $scale

    echo -e "\npgadmin\n"
    pgadmin/start-service.sh $scale
}

do_stop()
{
    echo -e "\npgadmin\n"
    pgadmin/stop-service.sh $scale

    echo -e "\npostgresql\n"
    postgresql/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\npostgresql\n"
    postgresql/deploy-service.sh $scale

    echo -e "\npgadmin\n"
    pgadmin/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\npgadmin\n"
    pgadmin/clean-service.sh $scale

    echo -e "\npostgresql\n"
    postgresql/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\npgadmin\n"
    pgadmin/status-service.sh $scale

    echo -e "\npostgresql\n"
    postgresql/status-service.sh $scale
}

do_ops $1
