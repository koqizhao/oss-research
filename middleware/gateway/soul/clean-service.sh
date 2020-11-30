#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" .

source common.sh

servers=(${bootstrap_servers[@]})
component=$bootstrap_component
batch_clean

servers=(${admin_servers[@]})
component=$admin_component
batch_clean

mysql_db_exec clean.sql
clean_all ${admin_servers[@]} ${bootstrap_servers[@]}
