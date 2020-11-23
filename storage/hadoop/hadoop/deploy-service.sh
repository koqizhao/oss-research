#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=hadoop-3.2.1

deploy()
{
    server=$1
    node_type=$2

    ssh $server "echo '$PASSWORD' | sudo -S apt install -y ssh pdsh;"
    ssh $server "echo '$PASSWORD' | sudo -S sh -c \"echo ssh > /etc/pdsh/rcmd_default\""

    ssh $server "mkdir -p $deploy_path/logs/$component"
    ssh $server "mkdir -p $deploy_path/tmp"

    scp ~/Software/hadoop/${deploy_file}.tar.gz $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf ${deploy_file}.tar.gz; mv $deploy_file $component; rm ${deploy_file}.tar.gz"
    ssh $server "echo '$PASSWORD' | sudo -S sh -c \
        \"echo 'export HADOOP_HOME=$deploy_path/$component' > /etc/profile.d/hadoop.sh; \
        chmod a+x /etc/profile.d/hadoop.sh;\""

    tmp_dp=`escape_slash $deploy_path/tmp`
    log_dp=`escape_slash $deploy_path/logs/$component`
    sed "s/H_LOG_DIR/$log_dp/g" hadoop-env.sh \
        | sed "s/TMP_DIR/$tmp_dp/g" \
        > hadoop-env.sh.tmp
    chmod a+x hadoop-env.sh.tmp
    scp hadoop-env.sh.tmp $server:$deploy_path/$component/etc/hadoop/hadoop-env.sh
    rm hadoop-env.sh.tmp

    if [ $node_type == "name" ] && [ $scale == "dist" ]; then
        for ds in ${data_nodes[@]}
        do
            echo $ds >> workers
        done
        scp workers $server:$deploy_path/$component/etc/hadoop/workers
        rm workers
    fi

    name_node_name=`ssh $name_node "hostname"`
    if [ $scale == "basic" ]; then
        name_node_name="localhost"
    fi
    sed "s/TMP_DIR/$tmp_dp/g" core-site.xml \
        | sed "s/NAME_NODE/$name_node_name/g" \
        > core-site.xml.tmp
    scp core-site.xml.tmp $server:$deploy_path/$component/etc/hadoop/core-site.xml
    rm core-site.xml.tmp

    dp=`escape_slash $deploy_path`
    sed "s/DEPLOY_PATH/$dp/g" hdfs-site.xml.$node_type > hdfs-site.xml.$node_type.tmp
    scp hdfs-site.xml.$node_type.tmp $server:$deploy_path/$component/etc/hadoop/hdfs-site.xml
    rm hdfs-site.xml.$node_type.tmp
}

deploy $name_node name

for server in ${data_nodes[@]}
do
    deploy $server data
done

echo -e "\nformat cluster\n"
if [ $scale == "basic" ]; then
    ssh $name_node "$deploy_path/$component/bin/hdfs namenode -format"
else
    ssh $name_node "$deploy_path/$component/bin/hdfs namenode -format hadoop-cluster"
fi

echo -e "\nstart cluster\n"
ssh $name_node "$deploy_path/$component/sbin/start-dfs.sh"

#deploy $hdfs_share_node data
#start_hdfs_share
