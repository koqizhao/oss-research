#! /bin/bash

echo -n "password: "
read -s PASSWORD
echo

source ~koqizhao/Share/servers.sh

deploy()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key add /media/sf_share/docker/gpg"
    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository \"deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu \$(lsb_release -cs) stable\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y docker-ce"
    ssh $1 "echo '$PASSWORD' | sudo -S apt upgrade -y"
    echo
}

for i in "${servers[@]}"
do
    deploy $i
    echo
done

