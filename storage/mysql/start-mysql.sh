#!/bin/bash

base_dir=/home/koqizhao/storage/mysql/mysql
cd $base_dir

touch mysql.out
chown mysql:mysql mysql.out
chmod 666 mysql.out
bin/mysqld_safe --defaults-file=defaults.conf --user=mysql > mysql.out 2>&1 &
sleep 1
