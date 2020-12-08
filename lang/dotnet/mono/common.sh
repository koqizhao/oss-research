#!/bin/bash

source ../common.sh

deploy_path=/home/koqizhao/Tools
component=dotnet
servers=(${dotnet_servers[@]})

apt_key_hash=A6A19B38D3D831EF
deb_repo="deb https://download.mono-project.com/repo/ubuntu stable-\$(lsb_release -cs) main"

remote_status()
{
    ssh $1 "mono --version"
}
