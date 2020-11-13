#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

deploy_file=consul_1.7.0_linux_amd64.zip

cluster_name=es-cluster
http_port=9200
seed_hosts='"192.168.56.11", "192.168.56.14"'
initial_master_nodes='"server1", "server4"'

deploy()
{
    server=$1
    node_name=$2

    echo -e "deploy server started: $server\n"

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop consul.service"
    ssh $server "mkdir -p ~/consul"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/consul/consul"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/consul/logs"

    scp ~/Software/consul/${deploy_file} $server:./consul/
    ssh $server "cd ~/consul/; tar xf ${deploy_file}; mv $deploy_file_extracted consul; rm ${deploy_file}"

    sed "s/CLUSTER_NAME/$cluster_name/g" consul.yml \
        | sed "s/NODE_NAME/$node_name/g" \
        | sed "s/NETWORK_HOST/$server/g" \
        | sed "s/HTTP_PORT/$http_port/g" \
        | sed "s/SEED_HOSTS/$seed_hosts/g" \
        | sed "s/INITIAL_MASTER_NODES/$initial_master_nodes/g" \
        > temp.yml
    scp temp.yml $server:./consul/consul/config/consul.yml
    rm temp.yml

    scp consul-env $server:./consul/consul/bin/
    scp jvm.options $server:./consul/consul/config/
    scp consul.sh $server:./consul/consul/
    scp consul.service $server:./consul/consul/

    ssh $server "echo '$PASSWORD' | sudo -S mv ~/consul/consul/consul.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start consul.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable consul.service"

    echo -e "\ndeploy server finished: $server"
}

deploy 192.168.56.11 server1
deploy 192.168.56.14 server4
