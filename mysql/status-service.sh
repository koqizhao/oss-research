#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" .

source common.sh

remote_status()
{
    remote_ps $1 mysqld
}

batch_status
