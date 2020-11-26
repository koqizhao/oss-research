#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt install -y curl gnupg2 ca-certificates lsb-release; "

    ssh $server "mkdir -p $deploy_path/$component"
    ssh $server "cd $deploy_path/$component; \
        curl -fsSL https://nginx.org/keys/nginx_signing.key > gpg; \
        echo '$PASSWORD' | sudo -S apt-key add gpg; rm gpg; \
        echo '$PASSWORD' | sudo -S apt-key fingerprint 7BD9BF62; \
        echo '$PASSWORD' | sudo -S add-apt-repository \
            \"deb http://nginx.org/packages/ubuntu \`lsb_release -cs\` nginx\"; \
        echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt install -y nginx; "

    scp conf/nginx.conf $1:$deploy_path/$component
    sed "s/NGINX_HOST/$server/g" conf/conf.d/default.conf \
        > default.conf.tmp
    scp default.conf.tmp $1:$deploy_path/$component/default.conf
    rm default.conf.tmp

    ssh $server "cd $deploy_path/$component; \
        echo '$PASSWORD' | sudo -S chown root:root *.conf; \
        echo '$PASSWORD' | sudo -S chmod 644 *.conf; \
        echo '$PASSWORD' | sudo -S mv nginx.conf /etc/nginx; \
        echo '$PASSWORD' | sudo -S mv default.conf /etc/nginx/conf.d; \
        echo '$PASSWORD' | sudo -S systemctl restart nginx; "
}

batch_deploy
