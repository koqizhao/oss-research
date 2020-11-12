#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..

source common.sh

servers=${bootstrap_servers[@]}
component=$bootstrap_component
batch_clean

servers=${admin_servers[@]}
component=$admin_component
batch_clean

clean_all ${admin_servers[@]} ${bootstrap_servers[@]}
