#!/bin/bash

source ~/Research/common/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    ./start-service.sh $scale
}

do_stop()
{
    ./stop-service.sh $scale
}

do_deploy()
{
    ./deploy-service.sh $scale
}

do_clean()
{
    ./clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    ./status-service.sh $scale
}

do_ops $1
