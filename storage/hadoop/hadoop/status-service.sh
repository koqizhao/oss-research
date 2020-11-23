#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

batch_status

echo -e "\nnfs gateway\n"
remote_ps $nfs_gateway_node portmap
remote_ps $nfs_gateway_node nfs3

echo -e "\nhdfs share\n"
ssh $name_node "$deploy_path/$component/bin/hdfs dfs -ls /share;"
