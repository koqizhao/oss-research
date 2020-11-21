#!/bin/bash

source ../common.sh

component=zookeeper
servers=(${zk_servers[@]})

read_server_pass

status()
{
    server=$1
    remote_systemctl $server status $component $PASSWORD
}
