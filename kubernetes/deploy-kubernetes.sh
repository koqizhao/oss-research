#! /bin/bash

set -e

echo -n "password: "
read -s PASSWORD
echo

source ~/Research/servers.sh

prerequisites="curl apt-transport-https"
#mirror_site=https://apt.kubernetes.io
mirror_site=https://mirrors.aliyun.com/kubernetes/apt
#gpg_site=https://packages.cloud.google.com/apt/doc/apt-key.gpg
gpg_site=https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg
artifact=kubernetes-xenial
kubernetes_packages="kubelet kubeadm kubectl"

deploy()
{
    echo "deploy $1 started"

    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y $prerequisites"
    ssh $1 "curl -fsSL $gpg_site > gpg"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key add gpg; rm gpg"
    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository \"deb $mirror_site $artifact main\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y $kubernetes_packages"
    #prevent auto upgrade
    ssh $1 "echo '$PASSWORD' | sudo -S apt-mark hold $kubernetes_packages"
    ssh $1 "echo '$PASSWORD' | sudo -S apt upgrade -y"
    echo

    echo "deploy $1 finished"
}

for i in "${servers[@]}"
do
    deploy $i
    echo
done
