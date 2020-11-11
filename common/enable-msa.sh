#!/bin/bash

source ~/Research/common/init.sh
read_server_pass

ops=$1
scale=$2

cd ~/Research

do_enable()
{
    echo -e "\nelk\n"
    elk/enable-components.sh $ops $scale
    echo

    echo -e "\nmysql\n"
    mysql/enable-components.sh $ops $scale
    echo

    echo -e "\napollo\n"
    apollo/enable-apollo.sh $ops $scale
    echo

    echo -e "\nzookeeper\n"
    zookeeper/enable-components.sh $ops $scale
    echo

    echo -e "\ndubbo\n"
    dubbo/enable-components.sh $ops $scale
    echo
}

do_disable()
{
    echo -e "\ndubbo\n"
    dubbo/enable-components.sh $ops $scale
    echo

    echo -e "\nzookeeper\n"
    zookeeper/enable-components.sh $ops $scale
    echo

    echo -e "\napollo\n"
    apollo/enable-apollo.sh $ops $scale
    echo

    echo -e "\nmysql\n"
    mysql/enable-components.sh $ops $scale
    echo

    echo -e "\nelk\n"
    elk/enable-components.sh $ops $scale
    echo
}

do_deploy()
{
    echo -e "\nelk\n"
    elk/enable-components.sh $ops $scale
    echo

    echo -e "\nmysql\n"
    mysql/enable-components.sh $ops $scale
    echo

    echo -e "\napollo\n"
    apollo/enable-apollo.sh $ops $scale
    echo

    echo -e "\nzookeeper\n"
    zookeeper/enable-components.sh $ops $scale
    echo

    echo -e "\ndubbo\n"
    dubbo/enable-components.sh $ops $scale
    echo
}

do_clean()
{
    echo -e "\ndubbo\n"
    dubbo/enable-components.sh $ops $scale
    echo

    echo -e "\nzookeeper\n"
    zookeeper/enable-components.sh $ops $scale
    echo

    echo -e "\napollo\n"
    apollo/enable-apollo.sh $ops $scale
    echo

    echo -e "\nmysql\n"
    mysql/enable-components.sh $ops $scale
    echo

    echo -e "\nelk\n"
    elk/enable-components.sh $ops $scale
    echo
}

source ~/Research/common/enable.sh
do_ops $1
