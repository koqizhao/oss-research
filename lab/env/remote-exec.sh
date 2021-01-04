#!/bin/bash

set -e

source ~/Research/lab/env/env.sh
read_server_pass

source ~/Research/lab/env/servers.sh

command="$1"

declare i
for i in ${servers[@]}
do
    echo -e "\n\nserver: $i\n\n"
    ssh $i "echo '$PASSWORD' | sudo -S su -c '$command'"
done
