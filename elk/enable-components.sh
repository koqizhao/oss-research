#!/bin/bash

source ~/Research/common/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\nelasticsearch\n"
    elasticsearch/remote-start.sh $scale

    echo -e "\nkibana\n"
    kibana/remote-start.sh $scale

    echo -e "\nfilebeat\n"
    filebeat/remote-start.sh $scale
}

do_stop()
{
    echo -e "\nfilebeat\n"
    filebeat/remote-stop.sh $scale

    echo -e "\nkibana\n"
    kibana/remote-stop.sh $scale

    echo -e "\nelasticsearch\n"
    elasticsearch/remote-stop.sh $scale
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

do_ops $1
