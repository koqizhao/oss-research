#!/bin/bash

set -e

echo -n "password: "
read -s PASSWORD
echo

source ~/Research/servers.sh

for i in "${servers[@]}"
do
    scp init-env.sh $i:./
    ssh $i "echo '$PASSWORD' | sudo -S sh init-env.sh; rm init-env.sh; echo '$PASSWORD' | sudo -S reboot" || echo
done

echo
