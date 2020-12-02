#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$2" .

source common.sh

do_start()
{
    echo -e "\netcd\n"
    etcd/start-service.sh $scale

    echo -e "\netcdkeeper\n"
    etcdkeeper/start-service.sh $scale

    echo -e "\netcd-manager\n"
    etcd-manager/start-service.sh $scale
}

do_stop()
{
    echo -e "\netcd-manager\n"
    etcd-manager/stop-service.sh $scale

    echo -e "\netcdkeeper\n"
    etcdkeeper/stop-service.sh $scale

    echo -e "\netcd\n"
    etcd/stop-service.sh $scale
}

do_deploy()
{
    echo -e "\netcd\n"
    etcd/deploy-service.sh $scale

    echo -e "\netcdkeeper\n"
    etcdkeeper/deploy-service.sh $scale

    echo -e "\netcd-manager\n"
    etcd-manager/deploy-service.sh $scale
}

do_clean()
{
    echo -e "\netcd-manager\n"
    etcd-manager/clean-service.sh $scale

    echo -e "\netcdkeeper\n"
    etcdkeeper/clean-service.sh $scale

    echo -e "\netcd\n"
    etcd/clean-service.sh $scale

    clean_all ${servers[@]} ${manager_servers[@]} ${keeper_servers[@]}
}

do_status()
{
    echo -e "\netcd-manager\n"
    etcd-manager/status-service.sh $scale

    echo -e "\netcdkeeper\n"
    etcdkeeper/status-service.sh $scale

    echo -e "\netcd\n"
    etcd/status-service.sh $scale
}

do_ops $1
