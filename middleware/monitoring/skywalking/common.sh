#!/bin/bash

deploy_path=/home/koqizhao/middleware/monitoring/trace/skywalking

#es_type=
es_type=-es7
deploy_file=apache-skywalking-apm${es_type}-8.4.0.tar.gz
deploy_folder=apache-skywalking-apm-bin${es_type}

remote_status()
{
    remote_ps $1 skywalking/$2
}

remote_start()
{
    ssh $1 "cd $deploy_path/$2; bin/$start_shell"
}

remote_stop()
{
    ssh $1 "pid=\`ps aux | grep java | grep $2 | awk '{ print \$2 }'\`; kill \$pid;"
}

remote_clean()
{
    ssh $1 "pid=\`ps aux | grep java | grep $2 | awk '{ print \$2 }'\`; kill \$pid;"
    ssh $1 "rm -rf $deploy_path/$2;"
    ssh $1 "rm -rf $deploy_path/logs/$2;"
}
