#!/bin/bash

deploy_path=/home/koqizhao/mysql
component=mysql

read_server_pass

remote_status()
{
    echo -e "\n$component\n"
    for server in ${servers[@]}
    do
        echo -e "\nremote server: $server\n"
        remote_ps $server mysqld
        echo
    done
}

remote_start()
{
    echo -e "\n$component\n"
    for server in ${servers[@]}
    do
        echo -e "\nremote server: $server\n"
        start $server $component
        echo
    done

    remote_status
}

remote_stop()
{
    echo -e "\n$component\n"
    for server in ${servers[@]}
    do
        echo -e "\nremote server: $server\n"
        stop $server $component
        echo
    done

    sleep 3
    remote_status
}

remote_deploy()
{
    echo -e "\n$component\n"
    for server in ${servers[@]}
    do
        echo -e "\ndeploy started: $server\n"
        deploy $server $component
        echo -e "\ndeploy finished: $server"
    done

    remote_status
}

remote_clean()
{
    echo -e "\n$component\n"
    for server in ${servers[@]}
    do
        echo -e "\nremote server: $server\n"
        clean $server $component
        echo -e "clean finished: $server\n"
    done

    sleep 3
    remote_status
}
