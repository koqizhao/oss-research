#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

kubernetes_packages=(kubeadm kubectl kubelet)

remote_clean()
{
    for i in ${kubernetes_packages[@]}
    do
        ssh $1 "echo '$PASSWORD' | sudo -S apt-mark unhold $i"
        ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y $i"
    done
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt upgrade -y"
    ssh $1 "echo '$PASSWORD' | sudo -S apt autoremove -y --purge"

    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository -r -y \"deb $mirror_site $artifact main\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key del BA07F4FB"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"

    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/kubelet"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/containerd"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/cni"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/calico"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/etcd"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/kubernetes"

    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
}

batch_clean
