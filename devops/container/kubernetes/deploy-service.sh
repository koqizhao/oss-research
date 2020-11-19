#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

#gpg_site=https://packages.cloud.google.com/apt/doc/apt-key.gpg
gpg_site=https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg

remote_deploy()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y curl apt-transport-https"
    ssh $1 "curl -fsSL $gpg_site > gpg; echo '$PASSWORD' | sudo -S apt-key add gpg; rm gpg;"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key fingerprint BA07F4FB"
    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository \"deb $mirror_site $artifact main\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y kubelet kubectl kubeadm"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-mark hold kubelet kubectl kubeadm"
    ssh $1 "echo '$PASSWORD' | sudo -S apt upgrade -y"
}

batch_deploy
