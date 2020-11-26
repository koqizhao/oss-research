#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_version=3.28.1-01

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path"

    scp ~/Software/repo-manager/nexus-$deploy_version-unix.tar.gz $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf nexus-$deploy_version-unix.tar.gz; \
        mv nexus-$deploy_version $component; rm nexus-$deploy_version-unix.tar.gz;"

    sed "s/USER/$user/g" conf/nexus.rc \
        > nexus.rc.tmp
    scp nexus.rc.tmp $server:$deploy_path/$component/bin/nexus.rc
    rm nexus.rc.tmp

    scp conf/nexus.vmoptions $server:$deploy_path/$component/bin
    scp conf/nexus.properties $server:$deploy_path/$component/etc

    ssh $server "echo '$PASSWORD' | sudo -S groupadd $group"
    ssh $server "echo '$PASSWORD' | sudo -S useradd -r -g $group -s /bin/false $user"

    ssh $1 "echo '$PASSWORD' | sudo -S chown -R $user:$group $deploy_path/$component"
    ssh $1 "echo '$PASSWORD' | sudo -S chown -R $user:$group $deploy_path/sonatype-work"

    dp=`escape_slash $deploy_path/$component`
    sed "s/DEPLOY_PATH/$dp/g" $component.service \
        | sed "s/GROUP/$group/g" \
        | sed "s/USER/$user/g" \
        > $component.service.tmp
    scp $component.service.tmp $server:$deploy_path/$component.service
    rm $component.service.tmp

    ssh $1 "echo '$PASSWORD' | sudo -S chown -R root:root $deploy_path/$component.service"
    ssh $1 "echo '$PASSWORD' | sudo -S mv $deploy_path/$component.service /etc/systemd/system"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl enable $component.service"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl start $component.service"
}

batch_deploy
