#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y $component"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt autoremove -y --purge"

    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository -r -y \"$apt_repo\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key del $gpg_pub"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"

    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/data/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/logs/$component"

    ssh $server "echo '$PASSWORD' | sudo -S userdel -rf rabbitmq"

    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/rabbitmq"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /usr/lib/rabbitmq"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/rabbitmq"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/log/rabbitmq"
}

batch_clean
