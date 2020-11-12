#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..

source common.sh

remote_stop()
{
    server=$1
    remote_disable $server $component $PASSWORD
}

batch_stop
