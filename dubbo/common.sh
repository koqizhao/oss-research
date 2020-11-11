#!/bin/bash

deploy_path=/home/koqizhao/dubbo

remote_start()
{
    echo -e "\n$component\n"
    for server in ${servers[@]}
    do
        echo -e "\nremote server: $server\n"
        ssh $server "cd $deploy_path/$component; ./start-$component.sh"
        ssh $server "ps aux | grep java | grep $component"
        echo
    done
}

remote_stop()
{
    echo -e "\n$component\n"
    for server in ${servers[@]}
    do
        echo -e "\nremote server: $server\n"
        ssh $server "pid=\`ps aux | grep java | grep $component | awk '{ print \$2 }'\`; kill \$pid;"
        ssh $server "ps aux | grep java | grep $component"
        echo
    done
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
}

remote_clean()
{
    echo -e "\n$component\n"
    for server in ${servers[@]}
    do
        echo -e "\nremote server: $server\n"
        ssh $server "pid=\`ps aux | grep java | grep $component | awk '{ print \$2 }'\`; kill \$pid;"
        ssh $server "rm -rf $deploy_path/$component;"
        echo -e "clean finished: $server\n"
    done
}
