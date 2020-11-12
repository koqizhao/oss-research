#!/bin/bash

source ~/Research/common/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nelasticsearch\n"
    elasticsearch/start-service.sh $scale

    echo -e "\nkibana\n"
    kibana/start-service.sh $scale

    echo -e "\nfilebeat\n"
    filebeat/start-service.sh $scale
}

do_stop()
{
    echo -e "\nfilebeat\n"
    filebeat/stop-service.sh $scale

    echo -e "\nkibana\n"
    kibana/stop-service.sh $scale

    echo -e "\nelasticsearch\n"
    elasticsearch/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nelasticsearch\n"
    elasticsearch/deploy-service.sh $scale

    echo -e "\nkibana\n"
    kibana/deploy-service.sh $scale

    echo -e "\nfilebeat\n"
    filebeat/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nfilebeat\n"
    filebeat/clean-service.sh $scale

    echo -e "\nkibana\n"
    kibana/clean-service.sh $scale

    echo -e "\nelasticsearch\n"
    elasticsearch/clean-service.sh $scale

    clean_all ${!es_servers_map[@]} ${kibana_servers[@]} ${filebeat_servers[@]}
}

do_status()
{
    echo -e "\nfilebeat\n"
    filebeat/status-service.sh $scale

    echo -e "\nkibana\n"
    kibana/status-service.sh $scale

    echo -e "\nelasticsearch\n"
    elasticsearch/status-service.sh $scale
}

do_ops $1
