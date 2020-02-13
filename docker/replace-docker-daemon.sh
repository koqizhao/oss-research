#! /bin/bash

set -e

echo -n "password: "
read -s PASSWORD
echo

source ~/Research/servers.sh

replace_docker_daemon()
{
    scp ./daemon.json $1:./
    ssh $1 "echo '$PASSWORD' | sudo -S mv -f daemon.json /etc/docker/"
    ssh $1 "echo '$PASSWORD' | sudo -S chown root:root /etc/docker/daemon.json"
    ssh $1 "echo '$PASSWORD' | sudo -S chmod 644 /etc/docker/daemon.json"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl restart docker"
}

for i in "${servers[@]}"
do
    replace_docker_daemon $i
    echo
done
