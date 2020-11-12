#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..

source common.sh

servers=${service_servers[@]}
component=$service_component
remote_start

servers=${client_servers[@]}
component=$client_component
remote_start
