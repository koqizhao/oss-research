#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

clean_nginx()
{
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

    $nginx_path/clean-service.sh $scale

    git checkout -- $nginx_path/../
}

remote_clean()
{
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/data/$component/webapp"
}

batch_stop

batch_clean

clean_nginx
