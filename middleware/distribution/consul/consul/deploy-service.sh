#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=consul_1.8.5_linux_amd64.zip

mkdir deploy
cp ~/Software/consul/$deploy_file deploy
cd deploy
unzip $deploy_file
rm $deploy_file
./consul keygen > gossip_key
./consul tls ca create
./consul tls cert create -server -dc $dc
./consul tls cert create -client -dc $dc
cd ..

gossip_key=`cat deploy/gossip_key`
gossip_key=`escape_slash $gossip_key`
data_dir=`escape_slash $deploy_path/data/$component`
log_dir=`escape_slash $deploy_path/logs/$component`
base_dir=`escape_slash $deploy_path/$component`
sed "s/DC/$dc/g" consul.hcl \
    | sed "s/GOSSIP_KEY/$gossip_key/g" \
    | sed "s/DATA_DIR/$data_dir/g" \
    | sed "s/BASE_DIR/$base_dir/g" \
    > deploy/consul.hcl
sed "s/BASE_DIR/$base_dir/g" consul.service \
    | sed "s/LOG_DIR/$log_dir/g" \
    | sed "s/USER/$user/g" \
    > consul.service.tmp

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path/data/$component"
    ssh $server "mkdir -p $deploy_path/logs/$component"
    ssh $server "touch $deploy_path/logs/$component/$component.log"
    ssh $server "mkdir -p $deploy_path/$component/conf"

    ssh $server "echo '$PASSWORD' | sudo -S useradd --system --home $deploy_path/$component/conf --shell /bin/false $user"

    scp deploy/consul-agent-ca.pem \
        deploy/$dc-server-consul-0.pem \
        deploy/$dc-server-consul-0-key.pem \
        deploy/consul.hcl \
        $server:$deploy_path/$component
    scp server.hcl $server:$deploy_path/$component
    ssh $server "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S mv *.pem conf/"
    ssh $server "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S mv *.hcl conf/"
    ssh $server "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S chown -R $user:$user conf"
    ssh $server "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S chown -R $user:$user $deploy_path/data/$component"
    ssh $server "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S chown -R $user:$user $deploy_path/logs/$component"
    ssh $server "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S chmod -R 777 $deploy_path/logs/$component"

    scp ~/Software/consul/$deploy_file $server:$deploy_path/$component
    ssh $server "echo '$PASSWORD' | sudo -S apt install -y unzip"
    ssh $server "cd $deploy_path/$component; unzip $deploy_file; rm $deploy_file"

    scp $component.service.tmp $server:$deploy_path/$component.service
    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/$component.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S chown root:root /etc/systemd/system/$component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start $component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable $component.service"
}

batch_deploy

rm consul.service.tmp
