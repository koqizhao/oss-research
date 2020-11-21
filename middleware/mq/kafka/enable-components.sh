#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nkafka\n"
    kafka/start-service.sh $scale

    echo -e "\nkafka-manager\n"
    kafka-manager/start-service.sh $scale

    echo -e "\nkafka-exporter\n"
    kafka-exporter/start-service.sh $scale
}

do_stop()
{
    echo -e "\nkafka-exporter\n"
    kafka-exporter/stop-service.sh $scale

    echo -e "\nkafka-manager\n"
    kafka-manager/stop-service.sh $scale

    echo -e "\nkafka\n"
    kafka/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nkafka\n"
    kafka/deploy-service.sh $scale

    echo -e "\nkafka-manager\n"
    kafka-manager/deploy-service.sh $scale

    echo -e "\nkafka-exporter\n"
    kafka-exporter/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nkafka-exporter\n"
    kafka-exporter/clean-service.sh $scale

    echo -e "\nkafka-manager\n"
    kafka-manager/clean-service.sh $scale

    echo -e "\nkafka\n"
    kafka/clean-service.sh $scale

    clean_all ${servers[@]} ${kafka_manager_servers[@]}
}

do_status()
{
    echo -e "\nkafka-exporter\n"
    kafka-exporter/status-service.sh $scale

    echo -e "\nkafka-manager\n"
    kafka-manager/status-service.sh $scale

    echo -e "\nkafka\n"
    kafka/status-service.sh $scale
}

do_ops $1
