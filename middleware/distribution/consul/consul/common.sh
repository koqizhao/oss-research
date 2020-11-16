#!/bin/bash

source ../common.sh

component=consul
servers=${consul_servers[@]}
user=consul
dc=lab

read_server_pass

status()
{
    server=$1
    remote_systemctl $server status $component $PASSWORD
}
