#!/bin/bash

deploy_path=/home/koqizhao/ops/gitlab

read_server_pass

remote_status()
{
    ssh $1 "echo '$PASSWORD' | sudo -S gitlab-ctl status"
}

remote_start()
{
    remote_enable $1 gitlab-runsvdir $PASSWORD
}

remote_stop()
{
    remote_disable $1 gitlab-runsvdir $PASSWORD
}
