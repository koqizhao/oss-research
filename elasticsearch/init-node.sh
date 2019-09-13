#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

server=$1

scp init-env.sh $server:./
ssh $server "echo '$PASSWORD' | sudo -S sh init-env.sh; rm init-env.sh; echo '$PASSWORD' | sudo -S reboot"

echo
