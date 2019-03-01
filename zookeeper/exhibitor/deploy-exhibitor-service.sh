#!/bin/bash

echo -n "password: "
read -s PASSWORD

WORK_DIR=zookeeper/exhibitor
SERVICE=exhibitor.service
JAR=exhibitor-1.6.0.jar

source ~/Share/servers.sh

deploy()
{
    ssh $1 "mkdir -p $WORK_DIR"
    ssh $1 "echo $1 > $WORK_DIR/hostip"

    ssh $1 "echo '$PASSWORD' | sudo -S systemctl stop $SERVICE"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf ${WORK_DIR}/$JAR"

    scp $SERVICE $1:$WORK_DIR
    scp exhibitor-1.6.0.jar $1:$WORK_DIR

    ssh $1 "echo '$PASSWORD' | sudo -S mv ${WORK_DIR}/$SERVICE /etc/systemd/system/"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl start $SERVICE"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl enable $SERVICE"
}

for i in `echo ${servers[@]}`
do
    deploy $i
done


