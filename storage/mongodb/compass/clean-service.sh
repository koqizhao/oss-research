#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    echo $PASSWORD | sudo -S apt purge -y mongodb-compass
    echo $PASSWORD | sudo -S apt autoremove --purge -y
}

batch_stop

batch_clean
