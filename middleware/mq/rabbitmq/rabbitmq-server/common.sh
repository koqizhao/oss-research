#!/bin/bash

source ../common.sh

component=rabbitmq-server

gpg_site=https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
gpg_pub=4D206F89
#os_dist="\$(lsb_release -cs)"
os_dist=bionic
apt_repo="deb https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu/ $os_dist main"

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
