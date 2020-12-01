#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\netcd\n"
    etcd/start-service.sh $scale
}

do_stop()
{
    echo -e "\netcd\n"
    etcd/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\netcd\n"
    etcd/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\netcd\n"
    etcd/clean-service.sh $scale

    clean_all ${servers[@]}
}

do_status()
{
    echo -e "\netcd\n"
    etcd/status-service.sh $scale
}

do_ops $1
