#!/bin/bash

source ../common.sh

component=konga
servers=(${konga_servers[@]})

pg_user=konga
pg_password=xx123456XX

remote_status()
{
    ssh $1 "pid=\`lsof -i:1337 | grep LISTEN | awk '{ print \$2 }'\`; \
        if [ -n \"\$pid\" ]; then ps aux | grep \$pid; fi;"
}

remote_start()
{
    ssh $1 "cd $deploy_path/$component; sh start-konga.sh; "
    sleep 5
}

remote_stop()
{
    ssh $1 "pid=\`lsof -i:1337 | grep LISTEN | awk '{ print \$2 }'\`; \
        if [ -n \"\$pid\" ]; then kill \$pid; fi;"
}
