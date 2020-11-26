#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=jenkins_2.249.3_all.deb
mirror_site=https://mirrors.aliyun.com/jenkins/debian-stable

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt install -y wget; "

    ssh $server "mkdir -p $deploy_path/$component"
    scp jenkins $server:$deploy_path/$component
    ssh $server "cd $deploy_path/$component; \
        wget $mirror_site/$deploy_file; \
        echo '$PASSWORD' | sudo -S apt install -y ./$deploy_file; \
        rm $deploy_file; \
        echo '$PASSWORD' | sudo -S chown root:root jenkins; \
        echo '$PASSWORD' | sudo -S chmod 644 jenkins; \
        echo '$PASSWORD' | sudo -S mv jenkins /etc/default; \
        echo '$PASSWORD' | sudo -S systemctl restart jenkins; "
}

batch_deploy
