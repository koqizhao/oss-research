#!/bin/bash

set -e

source ~/Research/lab/env/env.sh
read_server_pass

enable_ssh()
{
    server=$1
    echo $PASSWORD | ssh-copy-id koqizhao@$server 
}

source ~/Research/lab/env/servers.sh
for i in ${servers[@]}
do
    enable_ssh $i
done

echo
