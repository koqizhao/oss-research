#!/bin/bash

mysql_db_server=MYSQL_SERVER
mysql_db_user=MYSQL_USER
mysql_db_password=MYSQL_PASSWORD

java -jar soul-admin.jar --spring.datasource.url="jdbc:mysql://$mysql_db_server:3306/soul?useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull&failOverReadOnly=false&autoReconnect=true&useSSL=false" --spring.datasource.username=$mysql_db_user  --spring.datasource.password=$mysql_db_password > admin.out 2>&1 &
