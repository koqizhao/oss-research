#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_deploy()
{
    echo $PASSWORD | sudo -S snap install etcd-manager
}

batch_deploy
