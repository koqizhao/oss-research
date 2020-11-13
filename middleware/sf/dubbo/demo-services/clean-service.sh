#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" .

source common.sh

servers=${client_servers[@]}
component=$client_component
batch_clean

servers=${service_servers[@]}
component=$service_component
batch_clean

clean_all ${service_servers[@]} ${client_servers[@]}
