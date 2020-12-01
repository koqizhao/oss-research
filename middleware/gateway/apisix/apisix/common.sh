#!/bin/bash

source ../common.sh

component=apisix
apisix_work_dir=/usr/local/apisix

remote_status()
{
    remote_ps $1 $2
}

remote_start()
{
    ssh $server "cd $apisix_work_dir; echo '$PASSWORD' | sudo -S bin/apisix start; "
}

remote_stop()
{
    ssh $server "cd $apisix_work_dir; echo '$PASSWORD' | sudo -S bin/apisix stop; "
}
