#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

deploy_version=7.9.3
deploy_file=elasticsearch-oss-$deploy_version-linux-x86_64.tar.gz
deploy_file_extracted=elasticsearch-$deploy_version

scale="dist"
if [ -n "$1" ]
then
    scale=$1
fi

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source servers-$scale.sh

cluster_name=es-cluster
http_port=9200

deploy()
{
    server=$1
    node_name=$2

    echo -e "deploy server started: $server\n"

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop elasticsearch.service"
    ssh $server "mkdir -p ~/elasticsearch"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/elasticsearch/elasticsearch"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/elasticsearch/logs"

    scp ~/Software/elastic/${deploy_file} $server:./elasticsearch/
    ssh $server "cd ~/elasticsearch/; tar xf ${deploy_file}; mv $deploy_file_extracted elasticsearch; rm ${deploy_file}"

    sed "s/CLUSTER_NAME/$cluster_name/g" elasticsearch.yml \
        | sed "s/NODE_NAME/$node_name/g" \
        | sed "s/NETWORK_HOST/$server/g" \
        | sed "s/HTTP_PORT/$http_port/g" \
        | sed "s/SEED_HOSTS/$seed_hosts/g" \
        | sed "s/INITIAL_MASTER_NODES/$initial_master_nodes/g" \
        > temp.yml
    scp temp.yml $server:./elasticsearch/elasticsearch/config/elasticsearch.yml
    rm temp.yml

    scp elasticsearch-env $server:./elasticsearch/elasticsearch/bin/
    scp jvm.options $server:./elasticsearch/elasticsearch/config/
    scp elasticsearch.sh $server:./elasticsearch/elasticsearch/
    scp elasticsearch.service $server:./elasticsearch/elasticsearch/

    ssh $server "echo '$PASSWORD' | sudo -S mv ~/elasticsearch/elasticsearch/elasticsearch.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start elasticsearch.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable elasticsearch.service"

    echo -e "\ndeploy server finished: $server"
}

for k in ${servers[@]}
do
    v=${servers_map[$k]}
    deploy $k $v
done
