#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_start()
{
    ssh $1 "echo '$PASSWORD' | sudo -S docker container start $component"
}

batch_start
