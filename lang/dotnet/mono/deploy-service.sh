#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_deploy()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y curl gnupg apt-transport-https"

    ssh $1 "echo '$PASSWORD' | sudo -S apt-key adv \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key fingerprint $apt_key_hash"
    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository \"$deb_repo\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y $package"
}

batch_deploy
