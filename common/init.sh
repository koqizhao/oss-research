#!/bin/bash

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path

db_server=192.168.56.11
db_password=xx123456XX

source ~/Research/common/tool.sh
source ~/Research/common/remote.sh
source ~/Research/common/deploy.sh
