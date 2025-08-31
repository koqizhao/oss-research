#!/bin/bash

set -e

source ~/Research/lab/env/env.sh
read_server_pass

source ~/Research/lab/env/servers.sh

for i in ${servers[@]}
do
    ssh $i "echo '$PASSWORD' | sudo -S rm -f /home/koqizhao/aliyun.sources"
    scp ~/Research/lab/env/aliyun.sources $i:./
    ssh $i "echo '$PASSWORD' | sudo -S chown root:root /home/koqizhao/aliyun.sources"
    ssh $i "echo '$PASSWORD' | sudo -S mv /home/koqizhao/aliyun.sources /etc/apt/sources.list.d/"
    ssh $i "echo '$PASSWORD' | sudo -S apt update"
    echo
done
