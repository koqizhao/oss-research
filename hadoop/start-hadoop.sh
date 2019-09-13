#!/bin/bash

name_node=192.168.56.12
action=start
if [ -n "$1" ]
then
    action=$1
fi

ssh $name_node "~/hadoop/hadoop/sbin/$action-dfs.sh"
echo
