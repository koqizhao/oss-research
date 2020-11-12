#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..

source common.sh

start()
{
    server=$1
    remote_enable $server $component $PASSWORD
}

remote_start
