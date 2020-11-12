#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..

source common.sh

stop()
{
    server=$1
    remote_disable $server $component $PASSWORD
}

remote_stop
