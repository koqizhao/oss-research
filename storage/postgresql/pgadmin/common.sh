#!/bin/bash

source ../common.sh

component=pgadmin
servers=(${pg_servers[@]})

gpg_site=https://www.pgadmin.org/static/packages_pgadmin_org.pub
gpg_pub=210976F2
#apt_repo="deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main"
apt_repo="deb http://mirrors.ustc.edu.cn/postgresql/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main"

remote_status()
{
    echo $PASSWORD | sudo -S systemctl status --no-pager apache2
}

remote_start()
{
    echo $PASSWORD | sudo -S systemctl enable apache2
    echo $PASSWORD | sudo -S systemctl start apache2
}

remote_stop()
{
    echo $PASSWORD | sudo -S systemctl stop apache2
    echo $PASSWORD | sudo -S systemctl disable apache2
}
