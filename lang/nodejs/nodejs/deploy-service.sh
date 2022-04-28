#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

nodejs_version=16.x

remote_deploy()
{
    ssh $1 "curl -fsSL https://deb.nodesource.com/setup_$nodejs_version > setup_nodejs.sh; echo '$PASSWORD' | sudo -S /bin/bash ./setup_nodejs.sh; rm setup_nodejs.sh;"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y nodejs"
    ssh $1 "echo '$PASSWORD' | sudo npm install -g npm"

    ssh $1 "npm config set registry https://registry.npmmirror.com; \
        npm config get registry; \
        echo sass_binary_site=https://registry.npmmirror.com/binary.html?path=node-sass >> ~/.npmrc; "
}

batch_deploy
