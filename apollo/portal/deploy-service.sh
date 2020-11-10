#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

component=portal

project_path=/home/koqizhao/Projects/ctripcorp/apollo
deploy_file=$project_path/apollo-$component/target/apollo-$component-*-github.zip
deploy_path=/home/koqizhao/apollo
servers=$@

deploy()
{
    server=$1

    echo -e "\ndeploy started: $server\n"

    ssh $server "mkdir -p $deploy_path"

    scp $deploy_file $server:$deploy_path
    scp app.properties $server:$deploy_path
    scp application-github.properties $server:$deploy_path
    scp apollo-env.properties $server:$deploy_path
    scp startup.sh $server:$deploy_path
    scp deploy.sh $server:$deploy_path

    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S sh deploy.sh $component; rm deploy.sh;"

    echo -e "\ndeploy finished: $server"
}

for server in ${servers[@]}
do
    deploy $server
done
