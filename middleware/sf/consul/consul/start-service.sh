#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_start()
{
    server=$1
    remote_enable $server $component $PASSWORD
}

batch_start
