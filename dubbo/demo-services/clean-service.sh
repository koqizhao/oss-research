#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..

source common.sh

servers=${client_servers[@]}
component=$client_component
remote_clean

servers=${service_servers[@]}
component=$service_component
remote_clean

clean_all ${service_servers[@]} ${client_servers[@]}
