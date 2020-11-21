#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" .

source common.sh

servers=(${bootstrap_servers[@]})
component=$bootstrap_component
batch_stop

servers=(${admin_servers[@]})
component=$admin_component
batch_stop
