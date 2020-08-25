#!/bin/bash

WORK_DIR=zookeeper/zkui
DEPLOY_DIR=~/Projects/misc/zkui

current_dir=`pwd`

cd $DEPLOY_DIR
git pull
mvn clean package
cd $current_dir

deploy()
{
    ssh $1 "rm -rf $WORK_DIR"
    ssh $1 "mkdir -p $WORK_DIR/target"

    scp $DEPLOY_DIR/target/zkui-2.0-SNAPSHOT-jar-with-dependencies.jar $1:$WORK_DIR/target
    scp config.cfg $1:$WORK_DIR/
    scp zkui.sh $1:$WORK_DIR/
    ssh $1 "cd $WORK_DIR; ./zkui.sh start"

    echo
}

deploy $1
