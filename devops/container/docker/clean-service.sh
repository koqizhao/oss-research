#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y docker-ce docker-ce-cli containerd.io"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt upgrade -y"
    ssh $1 "echo '$PASSWORD' | sudo -S apt autoremove -y --purge"

    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository -r -y \"deb [arch=amd64] $mirror_site \$(lsb_release -cs) stable\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key del 0EBFCD88"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"

    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/docker"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/dockershim"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/docker"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/systemd/system/docker.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/systemd/system/docker.socket"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"

    ssh $1 "echo '$PASSWORD' | sudo -S sudo gpasswd -d $manager docker"
    ssh $1 "echo '$PASSWORD' | sudo -S sudo groupdel docker"

    ssh $server "echo '$PASSWORD' | sudo -S reboot"
}

batch_clean
