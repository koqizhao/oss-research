#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_version=2.0.3
deploy_file=kafka-eagle-bin-$deploy_version
deploy_file_web=kafka-eagle-web-$deploy_version-bin

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path"

    scp ~/Software/kafka/${deploy_file}.tar.gz $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf ${deploy_file}.tar.gz; \
        cd $deploy_file; tar xf ${deploy_file_web}.tar.gz; \
        mv kafka-eagle-web-$deploy_version $deploy_path/$component; \
        cd $deploy_path; rm ${deploy_file}.tar.gz; rm -rf $deploy_file"

    scp ke.sh $server:$deploy_path/$component/bin

    dp=`escape_slash $deploy_path/$component`
    sed "s/DEPLOY_PATH/$dp/g" system-config.properties \
        | sed "s/ZOOKEEPER_CONNECT/$zk_connect/g" \
        > system-config.properties.tmp
    scp system-config.properties.tmp $server:$deploy_path/$component/conf/system-config.properties
    rm system-config.properties.tmp

    sed "s/DEPLOY_PATH/$dp/g" start.sh \
        > start.sh.tmp
    chmod a+x start.sh.tmp
    scp start.sh.tmp $server:$deploy_path/$component/start.sh
    rm start.sh.tmp

    ssh $server "cd $deploy_path/$component; sh ./start.sh start"
}

batch_deploy
