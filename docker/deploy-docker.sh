#! /bin/bash

echo -n "password: "
read -s PASSWORD
echo

source ~/Research/servers.sh

prerequisites="curl apt-transport-https ca-certificates curl gnupg-agent software-properties-common"
#mirror_site=https://download.docker.com/linux/ubuntu
mirror_site=https://mirrors.aliyun.com/docker-ce/linux/ubuntu
docker_packages="docker-ce docker-ce-cli containerd.io"

deploy()
{
    echo "deploy $1 started"

    ssh $1 "echo '$PASSWORD' | sudo -S apt install $prerequisites"
    ssh $1 "curl -fsSL https://download.docker.com/linux/ubuntu/gpg > gpg"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key add gpg; rm gpg"
    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository \"deb [arch=amd64] $mirror_site \$(lsb_release -cs) stable\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y $docker_packages"
    ssh $1 "echo '$PASSWORD' | sudo -S apt upgrade -y"
    echo

    echo "deploy $1 finished"
}

for i in "${servers[@]}"
do
    deploy $i
    echo
done
