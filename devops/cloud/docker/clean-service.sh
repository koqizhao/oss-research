#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt upgrade -y"
    ssh $1 "echo '$PASSWORD' | sudo -S apt autoremove -y --purge"

    ssh $1 "echo '$PASSWORD' | sudo -S rm -f /etc/apt/sources.list.d/docker.list"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -f /etc/apt/keyrings/docker.asc"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"

    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/docker"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/containerd"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/docker"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/systemd/system/docker.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/systemd/system/docker.socket"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"

    ssh $1 "echo '$PASSWORD' | sudo -S sudo gpasswd -d $manager docker"
    ssh $1 "echo '$PASSWORD' | sudo -S sudo groupdel docker"

    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
}

batch_clean
