#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

external_url=https://gitlab.mydotey.com

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt install -y curl openssh-server ca-certificates tzdata; "

    ssh $server "mkdir -p $deploy_path/$component"
    #ssh $server "cd $deploy_path/$component; curl -fsSL https://packages.gitlab.com/gpg.key > gpg;"
    scp gpg $server:$deploy_path/$component
    ssh $server "echo '$PASSWORD' | sudo -S apt-key add gpg; rm gpg; \
        echo '$PASSWORD' | sudo -S apt-key fingerprint 51312F3F; \
        echo '$PASSWORD' | sudo -S add-apt-repository \"deb $mirror_site \$(lsb_release -cs) main\"; \
        echo '$PASSWORD' | sudo -S apt update; "
    ssh $server "echo '$PASSWORD' | sudo -S apt install -y debian-archive-keyring; \
        echo '$PASSWORD' | sudo -S EXTERNAL_URL=\"$external_url\" apt install -y gitlab-$version; "
}

batch_deploy
