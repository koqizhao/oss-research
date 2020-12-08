#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    rm -rf $deploy_path/$component
    ssh $1 "echo '$PASSWORD' | sudo -S update-alternatives --remove java \
        $deploy_path/$deploy_folder/bin/java"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$deploy_folder"
}

batch_clean
