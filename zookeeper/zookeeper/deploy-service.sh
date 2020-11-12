#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..

source common.sh

zk_file=apache-zookeeper-3.6.1-bin

get_myid()
{
    declare -i myid
    myid=0
    for server in ${servers[@]}
    do
        if [ $server == "$1" ]; then
            echo $myid
            return 0
        fi

        let myid+=1
    done
    echo "ERROR: bad myid" 1>&2
    return -1
}

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path/data"

    scp ~/Software/${zk_file}.tar.gz $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf ${zk_file}.tar.gz; mv $zk_file $component; rm ${zk_file}.tar.gz"
    scp zoo.cfg.$scale $server:$deploy_path/$component/conf/zoo.cfg
    scp java.env $server:$deploy_path/$component/conf/

    myid=`get_myid $server`
    ssh $server "echo $myid > myid; mv myid $deploy_path/data"

    scp zookeeper.service $server:$deploy_path
    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/zookeeper.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S chown root:root /etc/systemd/system/zookeeper.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start zookeeper.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable zookeeper.service"
}

batch_deploy
