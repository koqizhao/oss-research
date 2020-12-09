#!/bin/bash

bin/mysqld_safe --defaults-file=conf/defaults.cnf --user=mysql > ../logs/mysql/mysql.log 2>&1 &
sleep 3
