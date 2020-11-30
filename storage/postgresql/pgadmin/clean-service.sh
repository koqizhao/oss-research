#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    echo $PASSWORD | sudo -S apt purge -y pgadmin4* apache2*
    echo $PASSWORD | sudo -S apt update
    echo $PASSWORD | sudo -S apt upgrade -y
    echo $PASSWORD | sudo -S apt autoremove -y --purge

    echo $PASSWORD | sudo -S add-apt-repository -r -y "$apt_repo"
    echo $PASSWORD | sudo -S apt-key del $gpg_pub
    echo $PASSWORD | sudo -S apt update

    echo $PASSWORD | sudo -S rm -rf /etc/postgresql-common
    echo $PASSWORD | sudo -S rm -rf /usr/pgadmin4
    echo $PASSWORD | sudo -S rm -rf /usr/lib/postgresql
    echo $PASSWORD | sudo -S rm -rf /usr/share/postgresql
    echo $PASSWORD | sudo -S rm -rf /usr/share/postgresql-common
    echo $PASSWORD | sudo -S rm -rf /var/lib/pgadmin
    echo $PASSWORD | sudo -S rm -rf /var/log/pgadmin

    echo $PASSWORD | sudo -S rm -rf /etc/apache2
    echo $PASSWORD | sudo -S rm -rf /usr/lib/apache2
    echo $PASSWORD | sudo -S rm -rf /usr/share/apache2
    echo $PASSWORD | sudo -S rm -rf /var/lib/apache2
    echo $PASSWORD | sudo -S rm -rf /var/log/apache2
}

batch_clean
