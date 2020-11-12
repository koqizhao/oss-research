#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..

source common.sh

deploy_version=7.9.3
deploy_file=elasticsearch-oss-$deploy_version-linux-x86_64.tar.gz
deploy_file_extracted=elasticsearch-$deploy_version

cluster_name=es-cluster
http_port=9200

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/data/$component"

    scp ~/Software/elastic/${deploy_file} $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf ${deploy_file}; mv $deploy_file_extracted $component; rm ${deploy_file}"

    node_name=${es_servers_map[$server]}
    sed "s/CLUSTER_NAME/$cluster_name/g" elasticsearch.yml \
        | sed "s/NODE_NAME/$node_name/g" \
        | sed "s/NETWORK_HOST/$server/g" \
        | sed "s/HTTP_PORT/$http_port/g" \
        | sed "s/SEED_HOSTS/$seed_hosts/g" \
        | sed "s/INITIAL_MASTER_NODES/$initial_master_nodes/g" \
        > temp.yml
    scp temp.yml $server:$deploy_path/$component/config/elasticsearch.yml
    rm temp.yml

    scp elasticsearch-env $server:$deploy_path/$component/bin/
    scp jvm.options $server:$deploy_path/$component/config/
    scp elasticsearch.sh $server:$deploy_path/$component
    scp elasticsearch.service $server:$deploy_path/$component

    ssh $server "echo '$PASSWORD' | sudo -S chown root:root $deploy_path/$component/elasticsearch.service"
    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/$component/elasticsearch.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start elasticsearch.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable elasticsearch.service"
}

batch_deploy
