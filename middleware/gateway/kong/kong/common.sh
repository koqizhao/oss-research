#!/bin/bash

source ../common.sh

component=kong

remote_status()
{
    ssh $1 "cd $deploy_path/$component; \
        kong health --prefix $deploy_path/$component; "
}

remote_start()
{
    ssh $1 "cd $deploy_path/$component; \
        kong start -c conf/kong.conf; "
}

remote_stop()
{
    ssh $1 "cd $deploy_path/$component; \
        kong stop --prefix $deploy_path/$component; "
}
