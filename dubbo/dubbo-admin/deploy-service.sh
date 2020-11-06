#!/bin/bash

DEPLOY_DIR=dubbo/dubbo-admin
PROJECT_DIR=~/Projects/apache/dubbo/dubbo-admin

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source ./servers.sh

cd $PROJECT_DIR
git checkout -- .
git pull
cp -f $work_path/application.properties dubbo-admin-server/src/main/resources/
mvn clean package -Dmaven.test.skip=true
git checkout -- .
cd $work_path

deploy()
{
    ssh $1 "rm -rf $DEPLOY_DIR"
    ssh $1 "mkdir -p $DEPLOY_DIR"

    scp $PROJECT_DIR/dubbo-admin-distribution/target/dubbo-admin-0.2.0-SNAPSHOT.jar $1:$DEPLOY_DIR
    scp start-dubbo-admin.sh $1:$DEPLOY_DIR
    ssh $1 "cd $DEPLOY_DIR; ./start-dubbo-admin.sh"

    echo
}

for server in ${servers[@]}
do
    echo "remote server: $server"
    deploy $server
    echo
done
