#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y nodejs"
    ssh $1 "echo '$PASSWORD' | sudo -S apt autoremove -y --purge"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -f /etc/apt/sources.list.d/nodesource.list"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "rm -f ~/.npmrc; rm -rf ~/.npm; "
}

batch_clean
