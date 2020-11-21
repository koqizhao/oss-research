#!/bin/bash

deploy_path=/home/koqizhao/sf/sentinel
component=sentinel-dashboard
servers=(${sentinel_servers[@]})

remote_status()
{
    remote_ps $1 $2
}

remote_start()
{
    ssh $1 "cd $deploy_path/$2; ./start-$2.sh"
}

remote_stop()
{
    ssh $1 "pid=\`ps aux | grep java | grep $2 | awk '{ print \$2 }'\`; kill \$pid;"
}

remote_clean()
{
    ssh $1 "pid=\`ps aux | grep java | grep $2 | awk '{ print \$2 }'\`; kill \$pid;"
    ssh $1 "rm -rf $deploy_path/$2;"
}
