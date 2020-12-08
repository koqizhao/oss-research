#!/bin/bash

source ../common.sh

deploy_path=/usr/lib/jvm
servers=(${jdk_servers[@]})
component=jdk

deploy_version=12.0.1
deploy_folder=$component-$deploy_version
deploy_file=openjdk-${deploy_version}_linux-x64_bin.tar.gz
priority=888

remote_status()
{
    ssh $1 "echo '$PASSWORD' | sudo -S update-alternatives --display java"
    ssh $1 "java -version"
}
