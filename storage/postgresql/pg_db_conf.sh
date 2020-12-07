#!/bin/bash

pg_db_server=192.168.56.11
pg_db_user=dbuser
pg_db_password=xx123456XX

pg_deploy_path=/home/koqizhao/storage/postgresql/postgresql

pg_db_exec()
{
    pg_db_name="$2"
    if [ -z "$pg_db_name" ]; then
        pg_db_name=postgres
    fi
    declare sql_file=`basename $1`
    scp $1 $pg_db_server:$pg_deploy_path/$sql_file
    ssh $pg_db_server "PGPASSWORD='$pg_db_password' \
        psql --user='$pg_db_user' --dbname='$pg_db_name' -f '$pg_deploy_path/$sql_file'; "
    ssh $pg_db_server "rm $pg_deploy_path/$sql_file"
}
