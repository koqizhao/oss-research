#!/bin/bash

echo -n "password: "
read -s PASSWORD

enable_ssh()
{
    server=$1
    echo $PASSWORD | ssh-copy-id koqizhao@$server 
}

for i in $@
do
    enable_ssh $i
done
