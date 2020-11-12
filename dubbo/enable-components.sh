#!/bin/bash

source ~/Research/common/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\ndubbo-admin\n"
    dubbo-admin/start-service.sh $scale

    echo -e "\nsentinel\n"
    sentinel/start-service.sh $scale

    echo -e "\nsoul\n"
    soul/start-service.sh $scale

    echo -e "\ndemo-services\n"
    demo-services/start-service.sh $scale
}

do_stop()
{
    echo -e "\ndemo-services\n"
    demo-services/stop-service.sh $scale

    echo -e "\nsoul\n"
    soul/stop-service.sh $scale

    echo -e "\nsentinel\n"
    sentinel/stop-service.sh $scale

    echo -e "\ndubbo-admin\n"
    dubbo-admin/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\ndubbo-admin\n"
    dubbo-admin/deploy-service.sh $scale

    echo -e "\nsentinel\n"
    sentinel/deploy-service.sh $scale

    echo -e "\nsoul\n"
    soul/deploy-service.sh $scale

    echo -e "\ndemo-services\n"
    demo-services/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\ndemo-services\n"
    demo-services/clean-service.sh $scale

    echo -e "\nsoul\n"
    soul/clean-service.sh $scale

    echo -e "\nsentinel\n"
    sentinel/clean-service.sh $scale

    echo -e "\ndubbo-admin\n"
    dubbo-admin/clean-service.sh $scale

    clean_all ${dubbo_admin_servers[@]} ${sentinel_servers[@]} ${soul_admin_servers[@]} \
        ${soul_bootstrap_servers[@]} ${service_servers[@]} ${client_servers[@]}
}

do_status()
{
    echo -e "\ndemo-services\n"
    demo-services/status-service.sh $scale

    echo -e "\nsoul\n"
    soul/status-service.sh $scale

    echo -e "\nsentinel\n"
    sentinel/status-service.sh $scale

    echo -e "\ndubbo-admin\n"
    dubbo-admin/status-service.sh $scale
}

do_ops $1
