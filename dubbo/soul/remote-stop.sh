#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" .

source common.sh

servers=$bootstrap_servers
component=$bootstrap_component
remote_stop

servers=$admin_servers
component=$admin_component
remote_stop
