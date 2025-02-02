#!/bin/bash

deploy_file=repository-hdfs-7.3.2.zip

install_plugin()
{
    server=$1

    scp ~/Software/elastic/${deploy_file} $server:./elasticsearch/
    ssh $server "echo y | ~/elk/elasticsearch/bin/elasticsearch-plugin install file:////home/koqizhao/elk/${deploy_file}"
    ssh $server "rm ~/elk/${deploy_file}"
    echo
}

install_plugin 192.168.56.11
install_plugin 192.168.56.12
