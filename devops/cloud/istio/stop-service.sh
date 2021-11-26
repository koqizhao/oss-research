#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_stop()
{
    ssh $1 "pid=\`ps aux | grep kiali | grep -v grep | awk '{ print \$2 }'\`; kill \$pid;"
}

batch_stop
