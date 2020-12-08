#!/bin/bash

source ../common.sh

deploy_path=/usr/lib/jvm
servers=(${jdk_servers[@]})
component=openjdk
deploy_version=8
package=$component-$deploy_version-jdk

remote_status()
{
    ssh $1 "echo '$PASSWORD' | sudo -S update-alternatives --display java"
    ssh $1 "java -version"
}
