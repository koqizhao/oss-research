#!/bin/bash

name_node=192.168.56.11
hadoop_path=/home/koqizhao/storage/hadoop/hadoop

ssh $name_node "$hadoop_path/bin/hdfs dfs -mkdir -p /user/koqizhao/cat/logview;"
ssh $name_node "$hadoop_path/bin/hdfs dfs -mkdir -p /user/koqizhao/cat/dump;"
ssh $name_node "$hadoop_path/bin/hdfs dfs -mkdir -p /user/koqizhao/cat/remote;"
ssh $name_node "$hadoop_path/bin/hdfs dfs -chown -R koqizhao:koqizhao /user/koqizhao;"
ssh $name_node "$hadoop_path/bin/hdfs dfs -ls /user/koqizhao;"
