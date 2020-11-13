#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .
read_server_pass

source common.sh

do_start()
{
    echo -e "\nzookeeper\n"
    zookeeper/start-service.sh $scale

    echo -e "\nzkui\n"
    zkui/start-service.sh $scale
}

do_stop()
{
    echo -e "\nzkui\n"
    zkui/stop-service.sh $scale

    echo -e "\nzookeeper\n"
    zookeeper/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\nzookeeper\n"
    zookeeper/deploy-service.sh $scale

    echo -e "\nzkui\n"
    zkui/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\nzkui\n"
    zkui/clean-service.sh $scale

    echo -e "\nzookeeper\n"
    zookeeper/clean-service.sh $scale

    clean_all ${zookeeper_servers[@]} ${zk_servers[@]}
}

do_status()
{
    echo -e "\nzkui\n"
    zkui/status-service.sh $scale

    echo -e "\nzookeeper\n"
    zookeeper/status-service.sh $scale
}

do_ops $1
