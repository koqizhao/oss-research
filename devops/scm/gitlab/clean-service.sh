#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y debian-archive-keyring gitlab-$version"
    ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y postfix"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt upgrade -y"
    ssh $1 "echo '$PASSWORD' | sudo -S apt autoremove -y --purge"

    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository -r -y \"deb $mirror_site \$(lsb_release -cs) main\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key del 51312F3F"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"

    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
}

batch_clean
