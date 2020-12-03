#!/bin/bash

deploy_path=/home/koqizhao/storage/hadoop

read_server_pass

servers=`merge_array $name_node ${data_nodes[@]} ${nfs_gateway_nodes[@]}`

remote_status()
{
    remote_systemctl $1 status $2 $PASSWORD
}
