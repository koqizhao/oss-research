#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_deploy()
{
    ssh $1 "mkdir -p $deploy_path/$component"
    ssh $1 "mkdir -p $deploy_path/data/$component"
    ssh $1 "mkdir -p $deploy_path/logs/$component"

    ssh $1 "curl -fsSL $gpg_site > gpg; echo '$PASSWORD' | sudo -S apt-key add gpg; rm gpg;"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key fingerprint $gpg_pub"
    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository \"$apt_repo\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y $deploy_pkg"

    declare data_dir=`escape_slash $deploy_path/data/$component`
    declare log_dir=`escape_slash $deploy_path/logs/$component`
    sed "s/DATA_DIR/$data_dir/g" mongod.conf \
        | sed "s/LOG_DIR/$log_dir/g" \
        > mongod.conf.tmp
    scp mongod.conf.tmp $server:$deploy_path/mongod.conf
    rm mongod.conf.tmp

    ssh $1 "cd $deploy_path; \
        echo '$PASSWORD' | sudo -S chown root:root mongod.conf; \
        echo '$PASSWORD' | sudo -S chmod 644 mongod.conf; \
        echo '$PASSWORD' | sudo -S mv mongod.conf /etc; \
        echo '$PASSWORD' | sudo -S chown -R mongodb:mongodb $deploy_path/data/$component; \
        echo '$PASSWORD' | sudo -S chmod -R 755 $deploy_path/data/$component; \
        echo '$PASSWORD' | sudo -S chown -R mongodb:mongodb $deploy_path/logs/$component; \
        echo '$PASSWORD' | sudo -S chown -R 755 $deploy_path/logs/$component; "
}

batch_deploy

batch_start

# fix unknown
for s in ${servers[@]}
do
    ssh $s "cd $deploy_path; \
        echo '$PASSWORD' | sudo -S chown -R mongodb:mongodb $deploy_path/logs/$component; "
done
