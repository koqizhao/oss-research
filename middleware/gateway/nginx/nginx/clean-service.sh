#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y nginx"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt autoremove -y --purge"

    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository -r -y \
        \"deb http://nginx.org/packages/ubuntu \`lsb_release -cs\` nginx\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key del 7BD9BF62"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"

    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf /etc/nginx"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf /usr/lib/nginx"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf /usr/share/nginx"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf /var/log/nginx"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"

    ssh $server "echo '$PASSWORD' | sudo -S userdel -f nginx"
}

batch_clean
