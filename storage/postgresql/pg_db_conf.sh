#!/bin/bash

pg_db_server=192.168.56.11
pg_db_user=dbuser
pg_db_password=xx123456XX

pg_deploy_path=/home/koqizhao/storage/postgresql/postgresql

pg_db_exec()
{
    declare sql_file=`basename $1`
    declare db_name="$2"
    db_name=${db_name:-postgres}
    declare db_host=$3
    db_host=${db_host:-$pg_db_server}
    declare db_user=$4
    db_user=${db_user:-$pg_db_user}
    declare db_password=$5
    db_password=${db_password:-$pg_db_password}

    scp $1 $db_host:$pg_deploy_path/$sql_file
    ssh $db_host "PGPASSWORD='$db_password' \
        psql --user='$db_user' --dbname='$db_name' -f '$pg_deploy_path/$sql_file'; "
    ssh $db_host "rm $pg_deploy_path/$sql_file"
}
