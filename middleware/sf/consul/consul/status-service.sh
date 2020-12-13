#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_status()
{
    server=$1
    remote_systemctl $server status $component $PASSWORD
}

batch_status
