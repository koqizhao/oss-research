#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt install -y bind9; \
        echo '$PASSWORD' | sudo -S apt install -y dnsutils; "

    ssh $server "mkdir -p $deploy_path/$component"
    scp conf/* $server:$deploy_path/$component
    ssh $server "echo '$PASSWORD' | sudo -S chown -R root:bind $deploy_path/$component/*"
    ssh $server "echo '$PASSWORD' | sudo -S chmod -R 644 $deploy_path/$component/*"
}

deploy_primary()
{
    echo -e "\ndeploy primary ns: $1\n"

    ssh $1 "cd $deploy_path/$component; \
        echo '$PASSWORD' | sudo -S mv named.conf.local.primary.$scale /etc/bind/named.conf.local"
    ssh $1 "cd $deploy_path/$component; \
        echo '$PASSWORD' | sudo -S mv db.* /var/lib/bind"
    ssh $1 "echo '$PASSWORD' | sudo -S rm $deploy_path/$component/*"

    ssh $1 "echo '$PASSWORD' | sudo -S systemctl restart $service"
}

deploy_secondary()
{
    echo -e "\ndeploy secondary ns: $1\n"

    ssh $1 "cd $deploy_path/$component; \
        echo '$PASSWORD' | sudo -S mv named.conf.local.secondary /etc/bind/named.conf.local"
    ssh $1 "echo '$PASSWORD' | sudo -S rm $deploy_path/$component/*"

    ssh $1 "echo '$PASSWORD' | sudo -S systemctl restart $service"
}

deploy_cache()
{
    echo -e "\ndeploy cache ns: $1\n"

    ssh $1 "cd $deploy_path/$component; \
        echo '$PASSWORD' | sudo -S mv named.conf.options.cache /etc/bind/named.conf.options"
    ssh $1 "echo '$PASSWORD' | sudo -S rm $deploy_path/$component/*"

    ssh $1 "echo '$PASSWORD' | sudo -S systemctl restart $service"
}

batch_deploy

if [ $scale == "basic" ]; then
    deploy_primary $primary_server
else
    deploy_primary $primary_server
    deploy_secondary $secondary_server

    for s in ${cache_servers[@]}
    do
        deploy_cache $s
    done
fi
