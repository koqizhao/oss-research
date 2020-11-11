#!/bin/bash

if [ -z "$PASSWORD" ]; then
    echo -n "password: "
    read -s PASSWORD
    echo
fi

zk_file=apache-zookeeper-3.6.1-bin

scale="dist"
if [ -n "$1" ]
then
    scale=$1
fi

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path

deploy()
{
    echo -e "\ndeploy $1 started\n"

    ssh $1 "mkdir -p ~/zookeeper/data"

    scp ~/Software/${zk_file}.tar.gz $1:./zookeeper/
    ssh $1 "cd ~/zookeeper; tar xf ${zk_file}.tar.gz; mv $zk_file zookeeper; rm ${zk_file}.tar.gz"
    scp zoo.cfg.$scale $1:./zookeeper/zookeeper/conf/zoo.cfg
    scp java.env $1:./zookeeper/zookeeper/conf/

    ssh $1 "echo $2 > myid; mv myid ~/zookeeper/data"

    scp zookeeper.service $1:./zookeeper
    ssh $1 "echo '$PASSWORD' | sudo -S mv ~/zookeeper/zookeeper.service /etc/systemd/system/"
    ssh $1 "echo '$PASSWORD' | sudo -S chown root:root /etc/systemd/system/zookeeper.service"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl start zookeeper.service"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl enable zookeeper.service"

    echo "deploy $1 finished"
}

source servers-$scale.sh
machine_count=`echo ${#servers[@]}`

for i in `let machine_count=machine_count-1; seq 0 $machine_count`
do
    deploy ${servers[$i]} $i
    echo
done
