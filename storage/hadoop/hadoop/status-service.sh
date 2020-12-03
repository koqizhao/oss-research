#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

batch_status

echo -e "\nnfs gateway\n"
for server in ${nfs_gateway_nodes[@]}
do
    remote_ps $server portmap
    remote_ps $server nfs3
done

echo -e "\nhdfs share\n"
ssh $name_node "$deploy_path/$component/bin/hdfs dfs -ls /;"
ssh $name_node "$deploy_path/$component/bin/hdfs dfs -ls /share;"
