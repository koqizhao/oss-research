#!/bin/bash

project_path=/home/koqizhao/Projects/ctripcorp/apollo
deploy_path=/home/koqizhao/middleware/config/apollo

eureka_url=""
meta_servers=""
for s in ${config_servers[@]}
do
    if [ -z "$eureka_url" ]; then
        eureka_url="http://$s:38080/eureka/"
        meta_servers="http://$s:38080"
    else
        eureka_url="$eureka_url, http://$s:38080/eureka/"
        meta_servers="$meta_servers, http://$s:38080"
    fi
done

remote_start()
{
    ssh $1 "cd $deploy_path/$2; scripts/startup.sh"
}

remote_stop()
{
    ssh $1 "cd $deploy_path/$2; scripts/shutdown.sh;"
}

remote_status()
{
    remote_ps $1 $2
}

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path"

    deploy_file=$project_path/$component/target/$component-*-github.zip
    scp $deploy_file $server:$deploy_path
    scp app.properties $server:$deploy_path
    scp startup.sh $server:$deploy_path
    scp deploy.sh $server:$deploy_path

    scp_more $server

    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S sh deploy.sh $component; rm deploy.sh;"
    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S chown -R koqizhao:koqizhao $component;"
    ssh $server "cd $deploy_path/$component; scripts/startup.sh"
}

remote_clean()
{
    ssh $1 "cd $deploy_path/$component; scripts/shutdown.sh;"
    ssh $1 "rm -rf $deploy_path/$component; rm -rf /opt/logs/$appId"
}
