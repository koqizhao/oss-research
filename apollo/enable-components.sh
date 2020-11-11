#!/bin/bash

source ~/Research/common/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\ncomponent: config-service\n"
    config-service/remote-start.sh $scale

    echo -e "\ncomponent: admin-service\n"
    admin-service/remote-start.sh $scale

    echo -e "\ncomponent: portal\n"
    portal/remote-start.sh $scale
}

do_stop()
{
    echo -e "\ncomponent: portal\n"
    portal/remote-stop.sh $scale

    echo -e "\ncomponent: admin-service\n"
    admin-service/remote-stop.sh $scale

    echo -e "\ncomponent: config-service\n"
    config-service/remote-stop.sh ${config_servers[@]}
}

do_deploy()
{
    read_server_pass

    echo -e "\ncomponent: config-service\n"
    config-service/deploy-service.sh $scale

    echo -e "\ncomponent: admin-service\n"
    admin-service/deploy-service.sh $scale

    echo -e "\ncomponent: portal\n"
    portal/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\ncomponent: portal\n"
    portal/clean-service.sh $scale

    echo -e "\ncomponent: admin-service\n"
    admin-service/clean-service.sh $scale

    echo -e "\ncomponent: config-service\n"
    config-service/clean-service.sh $scale

    clean_all ${config_servers[@]} ${admin_servers[@]} ${portal_servers[@]}
}

do_ops $1
