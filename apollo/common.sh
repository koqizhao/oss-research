#!/bin/bash

project_path=/home/koqizhao/Projects/ctripcorp/apollo
deploy_path=/home/koqizhao/apollo

eureka_url=""
meta_servers=""
for s in ${config_servers[@]}
do
    if [ -z $eureka_url ]; then
        eureka_url="http://$s:38080/eureka/"
        meta_servers="http://$s:38080"
    else
        eureka_url="$eureka_url, http://$s:38080/eureka/"
        meta_servers="$meta_servers, http://$s:38080"
    fi
done

remote_start()
{
    for server in ${servers[@]}
    do
        echo -e "\nremote server: $server\n"
        ssh $server "cd $deploy_path/$component; scripts/startup.sh"
        echo
        sleep 1
        ssh $server "ps aux | grep $component"
        echo
    done
}

remote_stop()
{
    for server in ${servers[@]}
    do
        echo -e "\nremote server: $server\n"
        ssh $server "cd $deploy_path/$component; scripts/shutdown.sh;"
        echo
        sleep 5
        ssh $server "ps aux | grep $component"
        echo
    done
}

remote_deploy()
{
    deploy_file=$project_path/apollo-$component/target/apollo-$component-*-github.zip
    for server in ${servers[@]}
    do
        echo -e "\ndeploy started: $server\n"
        deploy $server
        echo -e "\ndeploy finished: $server"
    done
}

remote_clean()
{
    for server in ${servers[@]}
    do
        echo -e "\nclean started: $server\n"
        ssh $server "cd $deploy_path/$component; scripts/shutdown.sh;"
        ssh $server "rm -rf $deploy_path/$component; rm -rf /opt/logs/$appId"
        echo -e "clean finished: $server\n"
    done
}
