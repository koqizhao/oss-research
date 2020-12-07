#!/bin/bash

mysql_db_server=192.168.56.11
mysql_db_user=root
mysql_db_password=xx123456XX

mysql_deploy_path=/home/koqizhao/storage/mysql/mysql

mysql_db_exec()
{
    declare sql_file=`basename $1`
    tmp_dir=$mysql_deploy_path/..
    scp $1 $mysql_db_server:$tmp_dir/$sql_file
    ssh $mysql_db_server "cd $mysql_deploy_path; \
        bin/mysql --connect-expired-password --user=$mysql_db_user \
        --password=$mysql_db_password < $tmp_dir/$sql_file;"
    ssh $mysql_db_server "rm $tmp_dir/$sql_file"
}
