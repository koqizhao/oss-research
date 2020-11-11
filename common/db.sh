#!/bin/bash

db_server=192.168.56.11
db_password=xx123456XX

db_exec()
{
    sql=$1
    scp $sql $db_server:./
    ssh $db_server "cd ~/mysql/mysql; bin/mysql --connect-expired-password --user=root --password=$db_password < ~/$sql;"
    ssh $db_server "rm ~/$sql"
}
