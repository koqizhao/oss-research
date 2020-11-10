#!/bin/bash

WORK_DIR=zookeeper/zkui
DEPLOY_DIR=~/Projects/misc/zkui

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source ./servers.sh

cd $DEPLOY_DIR
git pull
mvn clean package
cd $work_path

deploy()
{
    echo -e "\ndeploy $1 started\n"

    ssh $1 "rm -rf $WORK_DIR"
    ssh $1 "mkdir -p $WORK_DIR"

    scp $DEPLOY_DIR/target/zkui-2.0-SNAPSHOT-jar-with-dependencies.jar $1:$WORK_DIR
    scp config.cfg $1:$WORK_DIR
    scp zkui.sh $1:$WORK_DIR
    ssh $1 "cd $WORK_DIR; ./zkui.sh start"

    echo
}

for server in ${servers[@]}
do
    deploy $server
done
