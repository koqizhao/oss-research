#!/bin/bash

source ../common.sh

component=gitlab
version=ce

#mirror_site=https://packages.gitlab.com/gitlab/gitlab-$version/ubuntu
mirror_site=http://mirrors.tuna.tsinghua.edu.cn/gitlab-$version/ubuntu

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
