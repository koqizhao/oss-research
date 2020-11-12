#!/bin/bash

deploy_path=/home/koqizhao/elk

read_server_pass

remote_status()
{
    echo -e "\n$component\n"
    for server in ${servers[@]}
    do
        echo -e "\nremote server: $server\n"
        remote_systemctl $server status $component $PASSWORD
        echo
    done
}

remote_start()
{
    echo -e "\n$component\n"
    for server in ${servers[@]}
    do
        echo -e "\nremote server: $server\n"
        remote_enable $server $component $PASSWORD
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
        remote_disable $server $component $PASSWORD
        echo
    done

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

    remote_status
}
