#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

component=thanos-query
servers=${thanos_query_servers[@]}
batch_status

component=thanos-sidecar
servers=${thanos_sidecar_servers[@]}
batch_status
