#!/bin/bash

set -e

source ~/Research/lab/env/env.sh
read_server_pass

source ~/Research/lab/env/servers.sh
source ~/Research/lab/deploy/remote.sh

for i in ${servers[@]}
do
    echo "\nserver: $i\n"
    ssh $i "echo '$PASSWORD' | sudo -S locale-gen zh_CN.utf8; \
        echo '$PASSWORD' | sudo -S update-locale LANG=zh_CN.UTF-8; \
        echo '$PASSWORD' | sudo -S rm -f /etc/localtime;
        echo '$PASSWORD' | sudo -S ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; "
    remote_reboot $i $PASSWORD
done
