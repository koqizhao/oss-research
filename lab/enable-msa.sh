#!/bin/bash

source ~/Research/lab/deploy/init.sh
read_server_pass

ops=$1
scale=$2

cd ~/Research

do_start()
{
    echo -e "\nelk\n"
    middleware/monitoring/elk/enable-components.sh $ops $scale
    echo

    echo -e "\nmysql\n"
    storage/mysql/enable-components.sh $ops $scale
    echo

    echo -e "\napollo\n"
    middleware/config/apollo/enable-components.sh $ops $scale
    echo

    echo -e "\nzookeeper\n"
    middleware/distribution/zookeeper/enable-components.sh $ops $scale
    echo

    echo -e "\ndubbo\n"
    middleware/sf/dubbo/enable-components.sh $ops $scale
    echo
}

do_stop()
{
    echo -e "\ndubbo\n"
    middleware/sf/dubbo/enable-components.sh $ops $scale
    echo

    echo -e "\nzookeeper\n"
    middleware/distribution/zookeeper/enable-components.sh $ops $scale
    echo

    echo -e "\napollo\n"
    middleware/config/apollo/enable-components.sh $ops $scale
    echo

    echo -e "\nmysql\n"
    storage/mysql/enable-components.sh $ops $scale
    echo

    echo -e "\nelk\n"
    middleware/monitoring/elk/enable-components.sh $ops $scale
    echo
}

do_deploy()
{
    echo -e "\nelk\n"
    middleware/monitoring/elk/enable-components.sh $ops $scale
    echo

    echo -e "\nmysql\n"
    storage/mysql/enable-components.sh $ops $scale
    echo

    echo -e "\napollo\n"
    middleware/config/apollo/enable-components.sh $ops $scale
    echo

    echo -e "\nzookeeper\n"
    middleware/distribution/zookeeper/enable-components.sh $ops $scale
    echo

    echo -e "\ndubbo\n"
    middleware/sf/dubbo/enable-components.sh $ops $scale
    echo
}

do_clean()
{
    echo -e "\ndubbo\n"
    middleware/sf/dubbo/enable-components.sh $ops $scale
    echo

    echo -e "\nzookeeper\n"
    middleware/distribution/zookeeper/enable-components.sh $ops $scale
    echo

    echo -e "\napollo\n"
    middleware/config/apollo/enable-components.sh $ops $scale
    echo

    echo -e "\nmysql\n"
    storage/mysql/enable-components.sh $ops $scale
    echo

    echo -e "\nelk\n"
    middleware/monitoring/elk/enable-components.sh $ops $scale
    echo
}

do_status()
{
    echo -e "\ndubbo\n"
    middleware/sf/dubbo/enable-components.sh $ops $scale
    echo

    echo -e "\nzookeeper\n"
    middleware/distribution/zookeeper/enable-components.sh $ops $scale
    echo

    echo -e "\napollo\n"
    middleware/config/apollo/enable-components.sh $ops $scale
    echo

    echo -e "\nmysql\n"
    storage/mysql/enable-components.sh $ops $scale
    echo

    echo -e "\nelk\n"
    middleware/monitoring/elk/enable-components.sh $ops $scale
    echo
}

do_ops $1
