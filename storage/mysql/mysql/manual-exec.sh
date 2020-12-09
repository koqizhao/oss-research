#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

#mysql_db_exec conf/test.sql 192.168.56.12 root 'xx123456XX'
