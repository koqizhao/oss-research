#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $1 "echo '$PASSWORD' | sudo -S gitlab-ctl cleanse"
    ssh $1 "echo '$PASSWORD' | sudo -S gitlab-ctl uninstall"

    ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y debian-archive-keyring gitlab-$version"
    ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y postfix"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt upgrade -y"
    ssh $1 "echo '$PASSWORD' | sudo -S apt autoremove -y --purge"

    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository -r -y \"deb $mirror_site \$(lsb_release -cs) main\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key del 51312F3F"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"

    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf /opt/gitlab"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf /etc/gitlab"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf /var/log/gitlab"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf /var/opt/gitlab"
    ssh $1 "clease=\`echo '$PASSWORD' | sudo -S ls /root | grep gitlab-cleanse\`; \
        if [ -n \"\$clease\" ]; then echo '$PASSWORD' | sudo -S rm -rf /root/\$clease; fi;"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"

    ssh $server "echo '$PASSWORD' | sudo -S userdel -f gitlab-www"
    ssh $server "echo '$PASSWORD' | sudo -S userdel -f git"
    ssh $server "echo '$PASSWORD' | sudo -S userdel -f gitlab-redis"
    ssh $server "echo '$PASSWORD' | sudo -S userdel -f gitlab-psql"
    ssh $server "echo '$PASSWORD' | sudo -S userdel -f registry"
    ssh $server "echo '$PASSWORD' | sudo -S userdel -f gitlab-prometheus"
}

batch_clean
