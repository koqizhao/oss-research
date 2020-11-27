#!/bin/bash

source ~/Research/lab/deploy/init.sh
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
    ssh $server "mkdir -p $deploy_path/logs/$component"

    scp ~/Software/elastic/${deploy_file} $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf ${deploy_file}; mv $deploy_file_extracted $component; rm ${deploy_file}"

    data_dir=`escape_slash $deploy_path/data/$component`
    log_dir=`escape_slash $deploy_path/logs/$component`
    node_name=${es_servers_map[$server]}
    sed "s/CLUSTER_NAME/$cluster_name/g" elasticsearch.yml \
        | sed "s/NODE_NAME/$node_name/g" \
        | sed "s/NETWORK_HOST/$server/g" \
        | sed "s/HTTP_PORT/$http_port/g" \
        | sed "s/SEED_HOSTS/$seed_hosts/g" \
        | sed "s/DATA_DIR/$data_dir/g" \
        | sed "s/LOG_DIR/$log_dir/g" \
        | sed "s/INITIAL_MASTER_NODES/$initial_master_nodes/g" \
        > elasticsearch.yml.tmp
    scp elasticsearch.yml.tmp $server:$deploy_path/$component/config/elasticsearch.yml
    rm elasticsearch.yml.tmp

    scp elasticsearch-env $server:$deploy_path/$component/bin/
    scp jvm.options $server:$deploy_path/$component/config/
    scp elasticsearch.sh $server:$deploy_path/$component

    base_dir=`escape_slash $deploy_path/$component`
    sed "s/BASE_DIR/$base_dir/g" $component.service \
        > $component.service.tmp 
    scp $component.service.tmp $server:$deploy_path/$component/$component.service
    rm $component.service.tmp

    ssh $server "echo '$PASSWORD' | sudo -S chown root:root $deploy_path/$component/elasticsearch.service"
    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/$component/elasticsearch.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start elasticsearch.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable elasticsearch.service"
}

batch_deploy
