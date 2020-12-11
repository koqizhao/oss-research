#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

admin_user="rabbitmq-admin"
admin_password="xx123456XX"

remote_deploy()
{
    server=$1

    ssh $1 "mkdir -p $deploy_path/$component"
    ssh $1 "mkdir -p $deploy_path/data/$component"
    ssh $1 "mkdir -p $deploy_path/logs/$component"

    ssh $1 "curl -fsSL $gpg_site > gpg; echo '$PASSWORD' | sudo -S apt-key add gpg; rm gpg;"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key fingerprint $gpg_pub"
    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository \"$apt_repo\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y $component"

    declare base_dir=`escape_slash $deploy_path/$component`
    declare data_dir=`escape_slash $deploy_path/data/$component`
    declare log_dir=`escape_slash $deploy_path/logs/$component`

    sed "s/LOG_DIR/$log_dir/g" rabbitmq.conf \
        > rabbitmq.conf.tmp
    scp rabbitmq.conf.tmp $server:$deploy_path/$component/rabbitmq.conf
    rm rabbitmq.conf.tmp

    sed "s/DATA_DIR/$data_dir/g" rabbitmq-env.conf \
        > rabbitmq-env.conf.tmp
    scp rabbitmq-env.conf.tmp $server:$deploy_path/$component/rabbitmq-env.conf
    rm rabbitmq-env.conf.tmp

    ssh $1 "cd $deploy_path/$component; \
        echo '$PASSWORD' | sudo -S chown root:root rabbitmq.conf; \
        echo '$PASSWORD' | sudo -S chmod 644 rabbitmq.conf; \
        echo '$PASSWORD' | sudo -S mv rabbitmq.conf /etc/rabbitmq/; \
        echo '$PASSWORD' | sudo -S chown root:root rabbitmq-env.conf; \
        echo '$PASSWORD' | sudo -S chmod 644 rabbitmq-env.conf; \
        echo '$PASSWORD' | sudo -S mv rabbitmq-env.conf /etc/rabbitmq/; \
        echo '$PASSWORD' | sudo -S chown -R rabbitmq:rabbitmq $deploy_path/data/$component; \
        echo '$PASSWORD' | sudo -S chown -R rabbitmq:rabbitmq $deploy_path/logs/$component; \
        echo '$PASSWORD' | sudo -S systemctl stop rabbitmq-server; \
        echo '$PASSWORD' | sudo -S systemctl start rabbitmq-server; \
        echo '$PASSWORD' | sudo -S rabbitmq-plugins enable rabbitmq_management; \
        echo '$PASSWORD' | sudo -S rabbitmqctl add_user $admin_user $admin_password; \
        echo '$PASSWORD' | sudo -S rabbitmqctl set_user_tags $admin_user administrator; "
}

batch_deploy
