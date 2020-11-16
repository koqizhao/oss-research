#!/bin/bash

bin/mysqld_safe --defaults-file=defaults.conf --user=mysql > ../logs/mysql.log 2>&1 &
sleep 3
