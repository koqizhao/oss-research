#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y openresty"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt autoremove -y --purge"

    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository -r -y \"$apt_repo\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key del $gpg_key_pub"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"

    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf /etc/openresty"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf /usr/local/openresty"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
}

batch_clean
