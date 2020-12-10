#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=mongodb-compass_1.24.1_amd64.deb

remote_deploy()
{
    echo $PASSWORD | sudo -S apt install -y ~/Software/mongodb/$deploy_file
}

batch_deploy

batch_start
