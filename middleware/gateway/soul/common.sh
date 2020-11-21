#!/bin/bash

deploy_path=/home/koqizhao/gateway/soul

admin_component=soul-admin
bootstrap_component=soul-bootstrap

admin_servers=(${soul_admin_servers[@]})
bootstrap_servers=(${soul_bootstrap_servers[@]})

remote_status()
{
    remote_ps $1 $2
}

remote_start()
{
    ssh $1 "cd $deploy_path/$2; sh ./start-$2.sh"
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
