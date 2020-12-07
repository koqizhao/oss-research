#!/bin/bash

deploy_path=/home/koqizhao/Tools

read_server_pass

remote_start()
{
    remote_status
}

remote_stop()
{
    remote_status
}

remote_clean()
{
    rm -rf $deploy_path/$component
}
