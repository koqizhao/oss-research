#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path/$component"

    ssh $server "echo '$PASSWORD' | sudo -S apt update; echo '$PASSWORD' | \
        sudo -S apt install -y --no-install-recommends curl gnupg ca-certificates; "
    ssh $server "cd $deploy_path/$component; \
        curl -fsSL https://openresty.org/package/pubkey.gpg > gpg; \
        echo '$PASSWORD' | sudo -S apt-key add gpg; rm gpg; \
        echo '$PASSWORD' | sudo -S apt-key fingerprint $gpg_key_pub; \
        echo '$PASSWORD' | sudo -S add-apt-repository \"$apt_repo\"; \
        echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt install -y openresty; "

    sed "s/NGINX_HOST/$server/g" conf/nginx.conf \
        > nginx.conf.tmp
    scp nginx.conf.tmp $1:$deploy_path/$component/nginx.conf
    rm nginx.conf.tmp
    ssh $server "cd $deploy_path/$component; \
        echo '$PASSWORD' | sudo -S chown root:root nginx.conf; \
        echo '$PASSWORD' | sudo -S chmod 644 nginx.conf; \
        echo '$PASSWORD' | sudo -S mv nginx.conf /etc/openresty; \
        echo '$PASSWORD' | sudo -S systemctl restart openresty; "
}

batch_deploy
