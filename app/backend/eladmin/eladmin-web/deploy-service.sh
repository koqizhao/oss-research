#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

project_path=~/Projects/misc/eladmin/eladmin-web

build()
{
    declare http_url=`escape_slash "$admin_server_http_url"`
    declare ws_url=`escape_slash "$admin_server_ws_url"`
    sed "s/HTTP_API_URL/$http_url/g" conf/.env.production \
        | sed "s/WS_API_URL/$ws_url/g" \
        > conf/.env.production.tmp

    cd $project_path
    git checkout -- .
    #git pull

    cp -f $work_path/conf/.env.production.tmp ./.env.production

    npm run build:prod
    git checkout -- .

    cd $work_path
    rm conf/.env.production.tmp
}

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/$component"
    ssh $server "mkdir -p $deploy_path/logs/$component"
    ssh $server "mkdir -p $deploy_path/data/$component"

    scp $project_path/$project/target/eladmin*.jar \
        $server:$deploy_path/$component/eladmin.jar

    declare log_dir=`escape_slash "$deploy_path/logs/$component"`
    sed "s/LOG_DIR/$log_dir/g" start.sh \
        > start.sh.tmp
    chmod a+x start.sh.tmp
    scp start.sh.tmp $server:$deploy_path/$component/start.sh
    rm start.sh.tmp
}

build

batch_deploy

batch_start
