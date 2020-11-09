#! /bin/bash

set -e

echo -n "password: "
read -s PASSWORD
echo

scale="dist"
if [ -n "$1" ]
then
    scale=$1
fi

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source servers-$scale.sh

prerequisites="curl apt-transport-https ca-certificates gnupg-agent software-properties-common"
#mirror_site=https://download.docker.com/linux/ubuntu
mirror_site=https://mirrors.aliyun.com/docker-ce/linux/ubuntu
docker_packages="docker-ce docker-ce-cli containerd.io"
os_release=focal

replace_docker_daemon()
{
    scp ./daemon.json $1:./
    ssh $1 "echo '$PASSWORD' | sudo -S mv -f daemon.json /etc/docker/"
    ssh $1 "echo '$PASSWORD' | sudo -S chown root:root /etc/docker/daemon.json"
    ssh $1 "echo '$PASSWORD' | sudo -S chmod 644 /etc/docker/daemon.json"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl restart docker"
}

deploy()
{
    echo "deploy $1 started"

    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y $prerequisites"
    ssh $1 "curl -fsSL $mirror_site/gpg > gpg"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key add gpg; rm gpg"
    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository \"deb [arch=amd64] $mirror_site $os_release stable\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y $docker_packages"
    ssh $1 "echo '$PASSWORD' | sudo -S apt upgrade -y"

    replace_docker_daemon $1

    echo

    echo "deploy $1 finished"
}

for i in "${servers[@]}"
do
    deploy $i
    echo
done
