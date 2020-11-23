#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

ssh $name_node "$deploy_path/$component/sbin/start-dfs.sh"
#start_hdfs_share
