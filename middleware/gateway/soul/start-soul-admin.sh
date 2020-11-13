#!/bin/bash

mysql_db_server=192.168.56.11
mysql_db_user=root
mysql_db_password=xx123456XX

java -jar soul-admin.jar --spring.datasource.url="jdbc:mysql://$mysql_db_server:3306/soul?useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull&failOverReadOnly=false&autoReconnect=true&useSSL=false" --spring.datasource.username=$mysql_db_user  --spring.datasource.password=$mysql_db_password > admin.out 2>&1 &
