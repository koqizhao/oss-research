#!/bin/bash

source ../common.sh

component=mongodb

deploy_version=4.4
deploy_pkg=mongodb-org
gpg_site=https://www.mongodb.org/static/pgp/server-$deploy_version.asc
#gpg_site=https://mirrors.tuna.tsinghua.edu.cn/mongodb/apt/ubuntu/dists/$(lsb_release -cs)/mongodb-org/$deploy_version/Release.gpg
#mirror_site=https://repo.mongodb.org
mirror_site=https://mirrors.tuna.tsinghua.edu.cn/mongodb
gpg_pub=90CFB1F5
apt_repo="deb [arch=amd64] $mirror_site/apt/ubuntu \$(lsb_release -cs)/mongodb-org/$deploy_version multiverse"

service_name=mongod

remote_status()
{
    remote_systemctl $1 status $service_name $PASSWORD
}

remote_start()
{
    remote_enable $1 $service_name $PASSWORD
}

remote_stop()
{
    remote_disable $1 $service_name $PASSWORD
}
