#!/bin/bash

deploy_path=/home/koqizhao/storage/redis/codis

read_server_pass

coordinator_name=zookeeper
coordinator_addr=192.168.56.11:2181

deploy_file_name=codis3.2.2-go1.9.2-linux
deploy_file=$deploy_file_name.tar.gz

remote_deploy_file()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path"
    ssh $server "mkdir -p $deploy_path/logs/$component"
    ssh $server "touch $deploy_path/logs/$component/$component.log; \
        chmod a+w $deploy_path/logs/$component/$component.log; "

    scp ~/Software/redis/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $deploy_file; rm $deploy_file; \
        mv $deploy_file_name $component; "

    ssh $server "mkdir -p $deploy_path/$component/conf"
}

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
    remote_kill $1 $2
}

remote_clean()
{
    ssh $1 "rm -rf $deploy_path/$2; rm -rf $deploy_path/logs/$2;"
}
