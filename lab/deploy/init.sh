#!/bin/bash

source ~/Research/lang/shell/util.sh
source ~/Research/lab/env/env.sh
source ~/Research/lab/deploy/remote.sh
source ~/Research/lab/deploy/deploy.sh

source ~/Research/storage/mysql/mysql_db_conf.sh
source ~/Research/storage/postgresql/pg_db_conf.sh
source ~/Research/storage/redis/redis_db_conf.sh

source ~/Research/devops/web-server/web_server_conf.sh

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
