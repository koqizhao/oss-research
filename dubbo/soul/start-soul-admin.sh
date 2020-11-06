#!/bin/bash

mysql_addr=192.168.56.11
mysql_user=root
mysql_password=xx123456XX

java -jar soul-admin.jar --spring.datasource.url="jdbc:mysql://$mysql_addr:3306/soul?useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull&failOverReadOnly=false&autoReconnect=true&useSSL=false" --spring.datasource.username=$mysql_user  --spring.datasource.password=$mysql_password > admin.out 2>&1 &
