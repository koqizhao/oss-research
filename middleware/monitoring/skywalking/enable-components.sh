#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\naggregator\n"
    aggregator/start-service.sh $scale

    echo -e "\nreceiver\n"
    receiver/start-service.sh $scale

    echo -e "\nwebapp\n"
    webapp/start-service.sh $scale
}

do_stop()
{
    echo -e "\nwebapp\n"
    webapp/stop-service.sh $scale

    echo -e "\nreceiver\n"
    receiver/stop-service.sh $scale

    echo -e "\naggregator\n"
    aggregator/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\naggregator\n"
    aggregator/deploy-service.sh $scale

    echo -e "\nreceiver\n"
    receiver/deploy-service.sh $scale

    echo -e "\nwebapp\n"
    webapp/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nwebapp\n"
    webapp/clean-service.sh $scale

    echo -e "\nreceiver\n"
    receiver/clean-service.sh $scale

    echo -e "\naggregator\n"
    aggregator/clean-service.sh $scale

    clean_all ${aggregator_servers[@]} ${receiver_servers[@]} ${webapp_servers[@]}
}

do_status()
{
    echo -e "\nwebapp\n"
    webapp/status-service.sh $scale

    echo -e "\nreceiver\n"
    receiver/status-service.sh $scale

    echo -e "\naggregator\n"
    aggregator/status-service.sh $scale
}

do_ops $1
