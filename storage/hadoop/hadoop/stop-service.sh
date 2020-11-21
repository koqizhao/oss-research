#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

stop_hdfs_share
ssh $name_node "$deploy_path/$component/sbin/stop-dfs.sh"
