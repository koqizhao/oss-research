#!/bin/bash

set -e

echo -n "password: "
read -s PASSWORD

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
