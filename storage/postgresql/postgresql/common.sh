#!/bin/bash

source ../common.sh

component=postgresql

gpg_site=https://www.postgresql.org/media/keys/ACCC4CF8.asc
gpg_pub=ACCC4CF8
apt_repo="deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main"
#apt_repo="deb http://mirrors.ustc.edu.cn/postgresql/repos/apt $(lsb_release -cs)-pgdg main"

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
