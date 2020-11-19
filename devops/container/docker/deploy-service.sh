#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

replace_docker_daemon()
{
    scp ./daemon.json $1:./
    ssh $1 "echo '$PASSWORD' | sudo -S mv -f daemon.json /etc/docker/"
    ssh $1 "echo '$PASSWORD' | sudo -S chown root:root /etc/docker/daemon.json"
    ssh $1 "echo '$PASSWORD' | sudo -S chmod 644 /etc/docker/daemon.json"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl restart docker"
}

remote_deploy()
{
    ssh $1 "echo '$PASSWORD' | sudo -S apt remove -y docker docker-engine docker.io containerd runc"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common"
    ssh $1 "curl -fsSL $mirror_site/gpg > gpg; echo '$PASSWORD' | sudo -S apt-key add gpg; rm gpg;"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key fingerprint 0EBFCD88"
    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository \"deb [arch=amd64] $mirror_site \$(lsb_release -cs) stable\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y docker-ce docker-ce-cli containerd.io"

    ssh $1 "echo '$PASSWORD' | sudo -S sudo usermod -aG docker $manager"

    replace_docker_daemon $1
}

batch_deploy
