#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_status()
{
    ssh $1 "echo '$PASSWORD' | sudo -S docker container ls | grep $component | grep -v grep"
}

batch_status
