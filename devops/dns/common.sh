#!/bin/bash

deploy_path=/home/koqizhao/ops/dns

read_server_pass

remote_status()
{
    remote_systemctl $1 status $service $PASSWORD
}

remote_start()
{
    remote_enable $1 $service $PASSWORD
}

remote_stop()
{
    remote_disable $1 $service $PASSWORD
}
