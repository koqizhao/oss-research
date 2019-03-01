#!/bin/bash

echo -n "password: "
read -s PASSWORD

JAVA_DIR=~koqizhao/java/1.8.0_161

source ~/Share/servers.sh

for i in ${servers[@]}
do
    ssh $i "echo $PASSWORD | sudo -S update-alternatives --install /usr/bin/jps jps $JAVA_DIR/bin/jps 100"
done

