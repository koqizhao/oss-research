#!/bin/bash

source ~/Research/common/init.sh
init_scale "$2" .
read_server_pass

source common.sh

do_start()
{
    echo -e "\nzookeeper\n"
    zookeeper/remote-start.sh $scale

    echo -e "\nzkui\n"
    zkui/remote-start.sh $scale
}

do_stop()
{
    echo -e "\nzkui\n"
    zkui/remote-stop.sh $scale

    echo -e "\nzookeeper\n"
    zookeeper/remote-stop.sh $scale
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

do_ops $1
