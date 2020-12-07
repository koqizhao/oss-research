#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nrocketmq\n"
    rocketmq/start-service.sh $scale

    echo -e "\nrocketmq-console\n"
    rocketmq-console/start-service.sh $scale
}

do_stop()
{
    echo -e "\nrocketmq-console\n"
    rocketmq-console/stop-service.sh $scale

    echo -e "\nrocketmq\n"
    rocketmq/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nrocketmq\n"
    rocketmq/deploy-service.sh $scale

    echo -e "\nrocketmq-console\n"
    rocketmq-console/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nrocketmq-console\n"
    rocketmq-console/clean-service.sh $scale

    echo -e "\nrocketmq\n"
    rocketmq/clean-service.sh $scale

    clean_all ${name_servers[@]} ${broker_role_server_map[@]} ${console_servers[@]}
}

do_status()
{
    echo -e "\nrocketmq-console\n"
    rocketmq-console/status-service.sh $scale

    echo -e "\nrocketmq\n"
    rocketmq/status-service.sh $scale
}

do_ops $1
