#!/bin/bash

deploy_path=/home/koqizhao/storage/shardingsphere
deploy_version=5.0.0-alpha

mysql_connector_file=mysql-connector-java-5.1.47.jar

registry_center_type=zookeeper
registry_center_address=192.168.56.11:2181

read_server_pass

servers=(`merge_array ${proxy_servers[@]} ${ui_servers[@]}`)
