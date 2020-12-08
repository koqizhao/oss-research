#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    rm -rf $deploy_path/$component
    rm -f ~/Desktop/GitExtensions.link

    echo $PASSWORD | sudo -S apt purge -y kdiff3
    echo $PASSWORD | sudo -S apt autoremove --purge -y
}

batch_clean
