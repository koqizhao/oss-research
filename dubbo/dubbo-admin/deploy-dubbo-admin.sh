#!/bin/bash

WORK_DIR=dubbo/dubbo-admin
DEPLOY_DIR=~/Projects/apache/dubbo/dubbo-admin

current_dir=`pwd`

cd $DEPLOY_DIR
git checkout -- .
git pull
cp -f $current_dir/application.properties dubbo-admin-server/src/main/resources/
mvn clean package -Dmaven.test.skip=true
git checkout -- .
cd $current_dir

deploy()
{
    ssh $1 "rm -rf $WORK_DIR"
    ssh $1 "mkdir -p $WORK_DIR"

    scp $DEPLOY_DIR/dubbo-admin-distribution/target/dubbo-admin-0.2.0-SNAPSHOT.jar $1:$WORK_DIR
    scp start.sh $1:$WORK_DIR
    ssh $1 "cd $WORK_DIR; ./start.sh"

    echo
}

deploy $1
