#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" .

source common.sh

servers=${service_servers[@]}
component=$service_component
batch_start

servers=${client_servers[@]}
component=$client_component
batch_start
