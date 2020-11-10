#!/bin/bash

if [ -z "$PASSWORD" ]; then
    echo -n "password: "
    read -s PASSWORD
    echo
fi

deploy_version=7.9.3
deploy_file=filebeat-oss-$deploy_version-linux-x86_64.tar.gz
deploy_file_extracted=filebeat-$deploy_version-linux-x86_64

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source servers.sh

deploy()
{
    server=$1

    echo -e "\ndeploy server started: $server\n"

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop filebeat.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/filebeat/filebeat"
    ssh $server "mkdir -p ~/filebeat"

    scp ~/Software/elastic/${deploy_file} $server:./filebeat/
    scp filebeat.service $server:./filebeat/
    scp filebeat.yml $server:./filebeat/

    ssh $server "cd ~/filebeat; tar xf $deploy_file; mv $deploy_file_extracted filebeat; mv filebeat.yml filebeat/; rm $deploy_file"
    ssh $server "echo '$PASSWORD' | sudo -S chown root:root ~/filebeat/filebeat/filebeat.yml"
    ssh $server "echo '$PASSWORD' | sudo -S mv ~/filebeat/filebeat.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start filebeat.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable filebeat.service"

    echo -e "\ndeploy server finished: $server"
}

for server in ${servers[@]}
do
    deploy $server
done
