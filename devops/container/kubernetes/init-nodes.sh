#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

for i in "${servers[@]}"
do
    scp init-env.sh $i:./
    ssh $i "echo '$PASSWORD' | sudo -S sh init-env.sh; rm init-env.sh;"
    ssh $i "echo '$PASSWORD' | sudo -S reboot" || echo
done
