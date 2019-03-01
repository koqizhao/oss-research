#!/bin/bash

echo -n "password: "
read -s PASSWORD

enable_ssh()
{
    server=$1
    ssh-copy-id q_zhao@$server
}

for i in $@
do
    enable_ssh $i
done

