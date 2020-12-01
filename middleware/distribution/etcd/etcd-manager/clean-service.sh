#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    echo $PASSWORD | sudo -S snap remove etcd-manager
}

batch_stop

batch_clean
