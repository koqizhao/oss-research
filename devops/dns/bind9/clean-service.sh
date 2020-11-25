#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y bind9 dnsutils"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt upgrade -y"
    ssh $1 "echo '$PASSWORD' | sudo -S apt autoremove -y --purge"

    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/bind"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/bind"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/cache/bind"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
}

batch_clean
