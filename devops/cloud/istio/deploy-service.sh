#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

tag=1.12.0
profile=demo
hub=docker.mirrors.ustc.edu.cn/istio

deploy_file_name=istio-$tag
deploy_file=$deploy_file_name-linux-amd64.tar.gz

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path"

    scp ~/Software/istio/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $deploy_file; \
        mv $deploy_file_name $component; rm $deploy_file; "
    scp -r ./itools $server:$deploy_path/$component

    ssh $server "cd $deploy_path/$component/itools; ./install.sh $tag $profile $hub; ./install-samples.sh;"
}

batch_deploy
