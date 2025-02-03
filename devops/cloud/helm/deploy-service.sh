#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file_name=helm-v3.8.2
deploy_file=$deploy_file_name-linux-amd64.tar.gz

helm_repo=https://charts.bitnami.com/bitnami

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path"

    scp ~/Software/helm/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $deploy_file; \
        mv linux-amd64 $component; rm $deploy_file; "
    
    dp=`escape_slash $deploy_path/$component`
    sed "s/DEPLOY_PATH/$dp/g" profile-helm.sh \
        > profile-helm.sh.tmp
    chmod a+x profile-helm.sh.tmp
    scp profile-helm.sh.tmp $1:$deploy_path/$component/profile-helm.sh
    rm profile-helm.sh.tmp
    ssh $server "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S chown root:root profile-helm.sh"
    ssh $server "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S mv profile-helm.sh /etc/profile.d/"

    ssh $server "cd $deploy_path/$component; ./helm repo add bitnami $helm_repo;"
}

batch_deploy
