#!/bin/bash

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path

mysql_db_server=192.168.56.11
mysql_db_password=xx123456XX

source ~/Research/lang/shell/util.sh
source ~/Research/lab/deploy/remote.sh
source ~/Research/lab/deploy/deploy.sh
