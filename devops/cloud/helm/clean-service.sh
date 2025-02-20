#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/.config/helm"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/.cache/helm"
    ssh $server "echo '$PASSWORD' | sudo -S rm -f /etc/profile.d/profile-helm.sh"
}

batch_clean
