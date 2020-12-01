#!/bin/bash

deploy_path=/home/koqizhao/middleware/distribution/etcd

read_server_pass

remote_status()
{
    remote_systemctl $1 status $2 $PASSWORD
}

remote_start()
{
    remote_enable $1 $2 $PASSWORD
}

remote_stop()
{
    remote_disable $1 $2 $PASSWORD
}
