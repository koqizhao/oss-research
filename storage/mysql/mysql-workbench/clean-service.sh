#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    echo $PASSWORD | sudo -S apt purge -y mysql-workbench-community libproj-dev
    echo $PASSWORD | sudo -S apt autoremove --purge -y

    echo $PASSWORD | sudo -S rm -rf ~/.mysql
}

batch_stop

batch_clean
