#!/bin/bash

if [ -z "$PASSWORD" ]; then
    echo -n "password: "
    read -s PASSWORD
    echo
fi

deploy_version=7.9.3
deploy_file=kibana-oss-$deploy_version-linux-x86_64.tar.gz
deploy_file_extracted=kibana-$deploy_version-linux-x86_64

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source servers.sh

deploy()
{
    server=$1

    echo -e "\ndeploy server started: $server\n"

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop kibana.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/kibana/kibana"
    ssh $server "mkdir -p ~/kibana/data"

    scp ~/Software/elastic/${deploy_file} $server:./kibana/
    scp kibana.service $server:./kibana/
    scp kibana.yml $server:./kibana/

    ssh $server "cd ~/kibana; tar xf $deploy_file; mv $deploy_file_extracted kibana; mv kibana.yml kibana/config/; rm $deploy_file"
    ssh $server "echo '$PASSWORD' | sudo -S mv ~/kibana/kibana.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start kibana.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable kibana.service"

    echo -e "\ndeploy server finished: $server"
}

for server in ${servers[@]}
do
    deploy $server
done
