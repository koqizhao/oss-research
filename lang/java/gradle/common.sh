#!/bin/bash

source ../common.sh

deploy_path=/home/koqizhao/Tools
component=gradle
servers=(${gradle_servers[@]})

remote_clean()
{
    rm -rf $deploy_path/$component
}

remote_status()
{
    gradle -v
}
