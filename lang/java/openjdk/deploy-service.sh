#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_deploy()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y $package"
}

batch_deploy
