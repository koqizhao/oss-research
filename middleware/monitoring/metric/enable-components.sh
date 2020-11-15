#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nprometheus\n"
    prometheus/start-service.sh $scale

    echo -e "\nthanos\n"
    thanos/start-service.sh $scale

    echo -e "\ngrafana\n"
    grafana/start-service.sh $scale

    echo -e "\nnode_exporter\n"
    node_exporter/start-service.sh $scale
}

do_stop()
{
    echo -e "\nnode_exporter\n"
    node_exporter/stop-service.sh $scale

    echo -e "\ngrafana\n"
    grafana/stop-service.sh $scale

    echo -e "\nthanos\n"
    thanos/stop-service.sh $scale

    echo -e "\nprometheus\n"
    prometheus/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nprometheus\n"
    prometheus/deploy-service.sh $scale

    echo -e "\nthanos\n"
    thanos/deploy-service.sh $scale

    echo -e "\ngrafana\n"
    grafana/deploy-service.sh $scale

    echo -e "\nnode_exporter\n"
    node_exporter/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nnode_exporter\n"
    node_exporter/clean-service.sh $scale

    echo -e "\ngrafana\n"
    grafana/clean-service.sh $scale

    echo -e "\nthanos\n"
    thanos/clean-service.sh $scale

    echo -e "\nprometheus\n"
    prometheus/clean-service.sh $scale

    clean_all ${prometheus_servers[@]} ${grafana_servers[@]} ${jmx_exporter_servers[@]} ${node_exporter_servers[@]}
}

do_status()
{
    echo -e "\nnode_exporter\n"
    node_exporter/status-service.sh $scale

    echo -e "\ngrafana\n"
    grafana/status-service.sh $scale

    echo -e "\nthanos\n"
    thanos/status-service.sh $scale

    echo -e "\nprometheus\n"
    prometheus/status-service.sh $scale
}

do_ops $1
