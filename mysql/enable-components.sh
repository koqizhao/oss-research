#!/bin/bash

source ~/Research/common/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    ./remote-start.sh $scale
}

do_stop()
{
    ./remote-stop.sh $scale
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

do_ops $1
