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
    git pull

    cp -f $work_path/conf/.env.production.tmp ./.env.production

    npm run build:prod
    git checkout -- .

    tar cf $component.dist.tar dist

    cd $work_path
    rm -f $component.dist.tar
    mv $project_path/$component.dist.tar ./
    rm conf/.env.production.tmp
}

deploy_nginx()
{
    cp nginx/nginx.conf $nginx_path/conf

    sed "s/web_servers/nginx_servers/g" ../servers-$scale.sh \
        > servers-$scale.sh.tmp
    chmod a+x servers-$scale.sh.tmp
    cp servers-$scale.sh.tmp $nginx_path/../servers-$scale.sh
    rm servers-$scale.sh.tmp

    dp=`escape_slash $deploy_path`
    sed "s/DEPLOY_PATH/$dp/g" nginx/common.sh \
        > nginx/common.sh.tmp
    cp nginx/common.sh.tmp $nginx_path/../common.sh
    rm nginx/common.sh.tmp

    $nginx_path/deploy-service.sh $scale

    git checkout -- $nginx_path/../
}

remote_deploy()
{
    server=$1

    scp $component.dist.tar $server:$deploy_path/data/$component

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop $component"

    ssh $server "cd $deploy_path/data/$component; \
        tar xf $component.dist.tar; \
        rm $component.dist.tar; \
        mv dist webapp; "

    ssh $server "echo '$PASSWORD' | sudo -S systemctl start $component"

    echo
}

build

deploy_nginx

batch_deploy
