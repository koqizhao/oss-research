#!/bin/bash

source ../common.sh

component=tidb

remote_status()
{
    echo -e "\ntiup\n"
    remote_ps $1 tiup

    echo -e "\ntidb\n"
    remote_ps $1 tidb-server
}

remote_start()
{
    ssh $1 "cd $deploy_path/$component; ./start.sh;"
}

remote_stop()
{
    remote_kill $1 tiup
}
