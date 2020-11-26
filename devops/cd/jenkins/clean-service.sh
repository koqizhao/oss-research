#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y jenkins"
    ssh $1 "echo '$PASSWORD' | sudo -S apt autoremove -y --purge"

    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
    ssh $1 "echo '$PASSWORD' | sudo -S userdel jenkins"
}

batch_clean
