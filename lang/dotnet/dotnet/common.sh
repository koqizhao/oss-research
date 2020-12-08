#!/bin/bash

source ../common.sh

deploy_path=/home/koqizhao/Tools
component=dotnet
servers=(${dotnet_servers[@]})

package=dotnet-sdk

remote_status()
{
    ssh $1 "dotnet --version"
}
