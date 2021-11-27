#!/bin/bash

source ../common.sh

component=kruise
master_server=${master_servers[0]}
servers=($master_server)

remote_status()
{
    ssh $server "kubectl get pods -n kruise-system;"
    echo
    ssh $server "$deploy_path/helm/helm list | grep kruise;"
}
