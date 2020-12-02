#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\ntomcat\n"
    tomcat/start-service.sh $scale
}

do_stop()
{
    echo -e "\ntomcat\n"
    tomcat/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\ntomcat\n"
    tomcat/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\ntomcat\n"
    tomcat/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\ntomcat\n"
    tomcat/status-service.sh $scale
}

do_ops $1
