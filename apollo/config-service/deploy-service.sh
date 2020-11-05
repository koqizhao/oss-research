#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

component=configservice

project_path=/home/koqizhao/Projects/ctripcorp/apollo
deploy_file=$project_path/apollo-$component/target/apollo-$component-*-github.zip
deploy_path=/home/koqizhao/apollo
servers=$@

deploy()
{
    server=$1

    echo -e "deploy started: $server\n"

    ssh $server "mkdir -p $deploy_path"

    scp $deploy_file $server:$deploy_path
    scp app.properties $server:$deploy_path
    scp startup.sh $server:$deploy_path
    scp deploy.sh $server:$deploy_path

    sed "s/SERVER_IP/$server/g" application-github.properties \
        | sed "s/SERVER_NAME/$server/g" \
        > temp.properties
    scp temp.properties $server:$deploy_path/application-github.properties
    rm temp.properties

    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S sh deploy.sh $component; rm deploy.sh;"

    echo -e "\ndeploy finished: $server"
}

for server in ${servers[@]}
do
    deploy $server
done
