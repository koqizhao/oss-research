#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_deploy()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y $package"
    ssh $1 "npm config set registry https://registry.npm.taobao.org; \
        npm config get registry; \
        echo sass_binary_site=https://npm.taobao.org/mirrors/node-sass/ >> ~/.npmrc; "
}

batch_deploy
