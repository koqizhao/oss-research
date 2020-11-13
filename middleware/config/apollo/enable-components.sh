#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nconfig-service\n"
    config-service/start-service.sh $scale

    echo -e "\nadmin-service\n"
    admin-service/start-service.sh $scale

    echo -e "\nportal\n"
    portal/start-service.sh $scale
}

do_stop()
{
    echo -e "\nportal\n"
    portal/stop-service.sh $scale

    echo -e "\nadmin-service\n"
    admin-service/stop-service.sh $scale

    echo -e "\nconfig-service\n"
    config-service/stop-service.sh ${config_servers[@]}
}

do_deploy()
{
    read_server_pass

    echo -e "\nconfig-service\n"
    config-service/deploy-service.sh $scale

    echo -e "\nadmin-service\n"
    admin-service/deploy-service.sh $scale

    echo -e "\nportal\n"
    portal/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nportal\n"
    portal/clean-service.sh $scale

    echo -e "\nadmin-service\n"
    admin-service/clean-service.sh $scale

    echo -e "\nconfig-service\n"
    config-service/clean-service.sh $scale

    clean_all ${config_servers[@]} ${admin_servers[@]} ${portal_servers[@]}
}

do_status()
{
    echo -e "\nportal\n"
    portal/status-service.sh $scale

    echo -e "\nadmin-service\n"
    admin-service/status-service.sh $scale

    echo -e "\nconfig-service\n"
    config-service/status-service.sh $scale
}

do_ops $1
