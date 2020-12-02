#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=mysql-workbench-community_8.0.21-1ubuntu20.04_amd64.deb

remote_deploy()
{
    echo $PASSWORD | sudo -S apt install -y libproj-dev ~/Software/mysql/$deploy_file
}

batch_deploy

batch_start
