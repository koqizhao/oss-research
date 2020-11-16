#!/bin/bash

#export DATA_SOURCE_NAME='user:password@(hostname:3306)
./mysqld_exporter --web.listen-address=":9104" \
    --config.my-cnf=./mysql.conf
