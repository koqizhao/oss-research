#!/bin/bash

base_dir=/home/koqizhao/mysql

sh -c "cd $base_dir; ./default/bin/mysqld_safe --basedir=$base_dir/default --datadir=$base_dir/data --user=mysql &"
