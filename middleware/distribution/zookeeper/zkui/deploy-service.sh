#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

project_path=~/Projects/misc/zkui

remote_deploy()
{
    server=$server
    ssh $server "rm -rf $deploy_path/$component"
    ssh $server "mkdir -p $deploy_path/$component"

    scp $project_path/target/zkui-2.0-SNAPSHOT-jar-with-dependencies.jar $server:$deploy_path/$component
    scp config.cfg.$scale $server:$deploy_path/$component/config.cfg

    base_dir=`escape_slash $deploy_path/$component`
    sed "s/BASE_DIR/$base_dir/g" zkui.sh \
        > zkui.sh.tmp
    chmod a+x zkui.sh.tmp
    scp zkui.sh.tmp $server:$deploy_path/$component/zkui.sh
    rm zkui.sh.tmp

    ssh $server "cd $deploy_path/$component; ./zkui.sh start"
}

batch_deploy
