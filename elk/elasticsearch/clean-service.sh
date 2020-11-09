#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

scale="dist"
if [ -n "$1" ]
then
    scale=$1
fi

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source servers-$scale.sh

clean()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop elasticsearch.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl disable elasticsearch.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm /etc/systemd/system/elasticsearch.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/elasticsearch"
}

for server in ${servers[@]}
do
    echo "remote server: $server"
    clean $server
    echo
done
