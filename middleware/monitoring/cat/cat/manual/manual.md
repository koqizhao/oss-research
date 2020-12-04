# Manual Steps

## Config Server

user/pass: admin/admin

和1台机器相关的配置改变后，必须重启该台机器。

如果修改了默认http端口8080，如改为18080，必须先修改server config里的端口号，并重启机器。否则应用监控页面打不开。

多网卡机器，默认使用第1个网卡的ip。可通过-Dhost.ip指定ip。

必须把cat部署在tomcat根目录下的cat子目录，即把cat.war复制到根目录下自动解压，不能直接使用根目录。

### Client Route

route-config.xml.tmp full automated

### Server Role

server-config.xml.tmp full automated

## Enable Hadoop Storage (optional)

1 deploy hadoop

2 ./init-hadoop.sh

3 enable hadoop in server config
