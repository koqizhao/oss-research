#!/bin/bash

source ../common.sh

component=tidb

remote_status()
{
    echo -e "\ntiup\n"
    remote_ps $1 tiup

    echo -e "\ntidb\n"
    remote_ps $1 tidb
}

remote_start()
{
    ssh $1 "cd $deploy_path/$component; ./start.sh;"
}

remote_stop()
{
    if [ $scale == "dist" ]; then
        ssh $1 "cd $deploy_path/$component; tiup cluster stop lab;"
    else
        remote_kill $1 tiup
    fi
}
