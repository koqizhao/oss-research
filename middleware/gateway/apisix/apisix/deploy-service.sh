#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_version=2.0
deploy_file_name=apache-apisix-$deploy_version-src
deploy_file=$deploy_file_name.tgz

http_proxy=47.111.98.255:28080
https_proxy=47.111.98.255:28443

build()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt install -y gcc make; \
        echo '$PASSWORD' | sudo -S apt install -y luarocks; "

    ssh $server "mkdir -p $deploy_path/$component"

    scp ~/Software/apisix/$deploy_file $server:$deploy_path/$component
    ssh $server "cd $deploy_path/$component; \
        tar xf $deploy_file; rm $deploy_file"

    ssh $server "cd $deploy_path/$component; \
        export http_proxy=$http_proxy; \
        export https_proxy=$https_proxy; \
        make deps; \
        cd $deploy_path; \
        tar cf $component.tar $component"
    rm -f $component.tar
    scp $server:$deploy_path/$component.tar ./

    ssh $server "rm -rf $deploy_path/$component; \
        rm -f $deploy_path/$component.tar"

    ssh $server "echo '$PASSWORD' | sudo -S apt purge -y gcc make; \
        echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt autoremove -y --purge"
}

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path"

    scp $component.tar $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $component.tar; rm $component.tar;"

    scp conf/config.yaml $server:$deploy_path/$component/conf
    scp conf/apisix.yaml $server:$deploy_path/$component/conf

    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/$component /usr/local"
    ssh $server "echo '$PASSWORD' | sudo -S chown -R root:root /usr/local/$component"
}

build ${servers[0]}

batch_deploy

batch_start
