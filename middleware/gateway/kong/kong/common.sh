#!/bin/bash

source ../common.sh

component=kong

kong_pg_user=kong
kong_pg_password=xx123456XX

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
