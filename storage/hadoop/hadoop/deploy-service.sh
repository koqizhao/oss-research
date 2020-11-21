#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=hadoop-3.2.0.tar.gz
deploy_file_extracted=hadoop-3.2.0

deploy_name()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S apt install -y ssh rsync;"

    ssh $server "mkdir -p $deploy_path/logs/$component"
    ssh $server "mkdir -p $deploy_path/data"
    ssh $server "mkdir -p $deploy_path/tmp"

    scp ~/Software/hadoop/${deploy_file} $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf ${deploy_file}; mv $deploy_file_extracted $component; rm ${deploy_file}"

    ld=`escape_slash $deploy_path/logs/$component`
    sed "s/H_LOG_DIR/$ld/g" hadoop-env.sh > hadoop-env.sh.tmp
    chmod a+x hadoop-env.sh.tmp
    scp hadoop-env.sh.tmp $server:$deploy_path/$component/etc/hadoop/hadoop-env.sh
    rm hadoop-env.sh.tmp

    scp workers $server:$deploy_path/$component/etc/hadoop/

    dp=`escape_slash $deploy_path/tmp`
    sed "s/TMP_DIR/$dp/g" core-site.xml > core-site.xml.tmp
    scp core-site.xml.tmp $server:$deploy_path/$component/etc/hadoop/core-site.xml
    rm core-site.xml.tmp

    dp=`escape_slash $deploy_path`
    sed "s/DEPLOY_PATH/$dp/g" hdfs-site.xml.name > hdfs-site.xml.name.tmp
    scp hdfs-site.xml.name.tmp $server:$deploy_path/$component/etc/hadoop/hdfs-site.xml
    rm hdfs-site.xml.name.tmp
}

deploy_data()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S apt install -y ssh rsync;"

    ssh $server "mkdir -p $deploy_path/logs/$component"
    ssh $server "mkdir -p $deploy_path/data"
    ssh $server "mkdir -p $deploy_path/tmp"

    scp ~/Software/hadoop/${deploy_file} $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf ${deploy_file}; mv $deploy_file_extracted $component; rm ${deploy_file}"

    ld=`escape_slash $deploy_path/logs/$component`
    sed "s/H_LOG_DIR/$ld/g" hadoop-env.sh > hadoop-env.sh.tmp
    chmod a+x hadoop-env.sh.tmp
    scp hadoop-env.sh.tmp $server:$deploy_path/$component/etc/hadoop/hadoop-env.sh
    rm hadoop-env.sh.tmp

    dp=`escape_slash $deploy_path/tmp`
    sed "s/TMP_DIR/$dp/g" core-site.xml > core-site.xml.tmp
    scp core-site.xml.tmp $server:$deploy_path/$component/etc/hadoop/core-site.xml
    rm core-site.xml.tmp

    dp=`escape_slash $deploy_path`
    sed "s/DEPLOY_PATH/$dp/g" hdfs-site.xml.data > hdfs-site.xml.data.tmp
    scp hdfs-site.xml.data.tmp $server:$deploy_path/$component/etc/hadoop/hdfs-site.xml
    rm hdfs-site.xml.data.tmp
}

deploy_name $name_node

for server in ${data_nodes[@]}
do
    deploy_data $server
done

ssh $name_node "$deploy_path/$component/bin/hdfs namenode -format"
ssh $name_node "$deploy_path/$component/sbin/start-dfs.sh"

start_hdfs_share
