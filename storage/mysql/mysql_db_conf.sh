#!/bin/bash

mysql_db_server=192.168.56.11
mysql_db_user=root
mysql_db_password=xx123456XX

mysql_deploy_path=/home/koqizhao/storage/mysql/mysql

mysql_db_exec()
{
    declare sql_file=`basename $1`
    declare db_host=$2
    db_host=${db_host:-$mysql_db_server}
    declare db_user=$3
    db_user=${db_user:-$mysql_db_user}
    declare db_password=$4
    db_password=${db_password:-$mysql_db_password}

    tmp_dir=$mysql_deploy_path/..
    scp $1 $db_host:$tmp_dir/$sql_file
    ssh $db_host "cd $mysql_deploy_path; \
        bin/mysql --connect-expired-password --user='$db_user' \
        --password='$db_password' < $tmp_dir/$sql_file;"
    ssh $db_host "rm $tmp_dir/$sql_file"
}
