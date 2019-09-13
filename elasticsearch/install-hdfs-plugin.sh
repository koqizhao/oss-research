#!/bin/bash

deploy_file=repository-hdfs-7.3.2.zip

install_plugin()
{
    server=$1

    scp ~/Software/elastic/${deploy_file} $server:./elasticsearch/
    ssh $server "echo y | ~/elasticsearch/elasticsearch/bin/elasticsearch-plugin install file:////home/koqizhao/elasticsearch/${deploy_file}"
    ssh $server "rm ~/elasticsearch/${deploy_file}"
    echo
}

install_plugin 192.168.56.11
install_plugin 192.168.56.14
