#!/bin/bash

source ~/Research/common/init.sh

scale=$2

cd ~/Research/dubbo

do_enable()
{
    echo -e "\ndubbo-admin\n"
    dubbo-admin/remote-start.sh $scale

    echo -e "\nsentinel\n"
    sentinel/remote-start.sh $scale

    echo -e "\nsoul\n"
    soul/remote-start.sh $scale

    echo -e "\ndemo-services\n"
    demo-services/remote-start.sh $scale
}

do_disable()
{
    echo -e "\ndemo-services\n"
    demo-services/remote-stop.sh $scale

    echo -e "\nsoul\n"
    soul/remote-stop.sh $scale

    echo -e "\nsentinel\n"
    sentinel/remote-stop.sh $scale

    echo -e "\ndubbo-admin\n"
    dubbo-admin/remote-stop.sh $scale
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
}

source ~/Research/common/enable.sh
do_ops $1
