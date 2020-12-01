#!/bin/bash

source ../common.sh

component=openresty

apt_repo="deb http://openresty.org/package/ubuntu \$(lsb_release -sc) main"
gpg_key_pub=D5EDEB74

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
