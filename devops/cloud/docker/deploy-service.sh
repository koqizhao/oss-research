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
    ssh $1 "mkdir -p $deploy_path/$component"

    ssh $1 "echo '$PASSWORD' | sudo -S apt remove -y docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y ca-certificates curl"
    ssh $1 "echo '$PASSWORD' | sudo -S install -m 0755 -d /etc/apt/keyrings"
    ssh $1 "echo '$PASSWORD' | sudo -S curl -fsSL $mirror_site/gpg -o /etc/apt/keyrings/docker.asc"
    ssh $1 "echo '$PASSWORD' | sudo -S chmod a+r /etc/apt/keyrings/docker.asc"
    ssh $1 "echo '$PASSWORD' | sudo -S echo \
        \"deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] $mirror_site \
        \$(. /etc/os-release && echo \"\${UBUNTU_CODENAME:-\$VERSION_CODENAME}\") stable\" > docker.list"
    ssh $1 "echo '$PASSWORD' | sudo -S mv docker.list /etc/apt/sources.list.d/docker.list"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"

    ssh $1 "echo '$PASSWORD' | sudo -S sudo usermod -aG docker $manager"

    replace_docker_daemon $1
}

batch_deploy
