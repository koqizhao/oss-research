#!/bin/bash

set -e

source ~/Research/lab/env/env.sh
read_server_pass

source ~/Research/lab/env/servers.sh

for i in ${servers[@]}
do
    ssh $i "echo '$PASSWORD' | sudo -S rm -f /home/koqizhao/sources.list"
    scp ~/Research/sources.list $i:./
    ssh $i "echo '$PASSWORD' | sudo -S chown root:root /home/koqizhao/sources.list"
    ssh $i "echo '$PASSWORD' | sudo -S mv /home/koqizhao/sources.list /etc/apt/"
    ssh $i "echo '$PASSWORD' | sudo -S apt update"
    echo
done
