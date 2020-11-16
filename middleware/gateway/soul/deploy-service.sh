#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" .

source common.sh

project_path=/home/koqizhao/Projects/misc/soul

remote_deploy()
{
    server=$1
    component=$2
    deploy_file=$project_path/$component/target/$component.jar

    ssh $server "mkdir -p $deploy_path/$component"

    scp $deploy_file $server:$deploy_path/$component
    if [ $component == $admin_component ]; then
        sed "s/MYSQL_SERVER/$mysql_db_server/g" start-$component.sh \
            | sed "s/MYSQL_USER/$mysql_db_user/g" \
            | sed "s/MYSQL_PASSWORD/$mysql_db_password/g" \
            > start-$component.sh.tmp
        chmod a+x start-$component.sh.tmp
        scp start-$component.sh.tmp $1:$deploy_path/$component/start-$component.sh
        rm start-$component.sh.tmp
    else
        scp start-$component.sh $server:$deploy_path/$component
    fi

    ssh $server "cd $deploy_path/$component; ./start-$component.sh"
}

servers=${admin_servers[@]}
component=$admin_component
batch_deploy

servers=${bootstrap_servers[@]}
component=$bootstrap_component
batch_deploy
