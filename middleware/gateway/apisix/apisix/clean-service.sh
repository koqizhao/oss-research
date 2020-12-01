#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $server "echo '$PASSWORD' | sudo -S apt purge -y luarocks; \
        echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt autoremove -y --purge; "

    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $apisix_work_dir"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
}

batch_stop
batch_clean
