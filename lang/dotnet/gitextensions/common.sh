#!/bin/bash

source ../common.sh

deploy_path=/home/koqizhao/Tools
component=GitExtensions
servers=(${gitext_servers[@]})

remote_status()
{
    ls $deploy_path/$component
}
