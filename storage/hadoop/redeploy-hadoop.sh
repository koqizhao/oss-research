#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

deploy_file=hadoop-3.2.0.tar.gz
deploy_file_extracted=hadoop-3.2.0
name_node=192.168.56.11
data_nodes=(192.168.56.12 192.168.56.13)

first_run=$1

deploy_name()
{
    server=$1

    echo -e "deploy server started: $server\n"

    ssh $server "mkdir -p ~/hadoop"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/hadoop/hadoop"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/hadoop/logs"

    scp ~/Software/hadoop/${deploy_file} $server:./hadoop/
    ssh $server "cd ~/hadoop/; tar xf ${deploy_file}; mv $deploy_file_extracted hadoop; rm ${deploy_file}"

    scp hadoop-env.sh $server:./hadoop/hadoop/etc/hadoop/
    scp workers $server:./hadoop/hadoop/etc/hadoop/
    scp core-site.xml $server:./hadoop/hadoop/etc/hadoop/core-site.xml
    scp hdfs-site.xml.name $server:./hadoop/hadoop/etc/hadoop/hdfs-site.xml

    echo -e "\ndeploy server finished: $server"
}

deploy_data()
{
    server=$1

    echo -e "deploy server started: $server\n"

    ssh $server "mkdir -p ~/hadoop"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/hadoop/hadoop"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/hadoop/logs"

    scp ~/Software/hadoop/${deploy_file} $server:./hadoop/
    ssh $server "cd ~/hadoop/; tar xf ${deploy_file}; mv $deploy_file_extracted hadoop; rm ${deploy_file}"

    scp hadoop-env.sh $server:./hadoop/hadoop/etc/hadoop/
    scp core-site.xml $server:./hadoop/hadoop/etc/hadoop/core-site.xml
    scp hdfs-site.xml.data $server:./hadoop/hadoop/etc/hadoop/hdfs-site.xml

    echo -e "\ndeploy server finished: $server"
}

if [ -z "$first_run" ]
then
    ssh $name_node "~/hadoop/hadoop/sbin/stop-dfs.sh"
fi

deploy_name $name_node

for server in ${data_nodes[@]}
do
    deploy_data $server
done

if [ -n "$first_run" ]
then
    echo -e "format name node"
    ssh $name_node "~/hadoop/hadoop/bin/hdfs namenode -format"
fi

echo -e "start dfs"
ssh $name_node "~/hadoop/hadoop/sbin/start-dfs.sh"
echo
