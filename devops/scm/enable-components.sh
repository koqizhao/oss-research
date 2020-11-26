#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\ngitlab\n"
    gitlab/start-service.sh $scale
}

do_stop()
{
    echo -e "\ngitlab\n"
    gitlab/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\ngitlab\n"
    gitlab/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\ngitlab\n"
    gitlab/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\ngitlab\n"
    gitlab/status-service.sh $scale
}

do_ops $1
