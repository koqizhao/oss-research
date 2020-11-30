#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $1 "echo '$PASSWORD' | sudo -S sudo sh -c \
        'echo $pg_pkg postgresql-$deploy_version/postrm_purge_data boolean true \
        | debconf-set-selections'"
    ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y postgresql*"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt upgrade -y"
    ssh $1 "echo '$PASSWORD' | sudo -S apt autoremove -y --purge"

    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository -r -y \"$apt_repo\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key del $gpg_pub"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"

    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/data/$component"

    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/postgresql"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/postgresql-common"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /usr/share/postgresql"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /usr/share/postgresql-common"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /usr/lib/postgresql"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/postgresql"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/log/postgresql"
}

batch_clean
