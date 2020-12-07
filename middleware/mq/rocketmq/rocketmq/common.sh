#!/bin/bash

source ../common.sh

component=rocketmq

start_name_servers()
{
    echo -e "\nname servers start\n"
    for s in ${name_servers[@]}
    do
        echo -e "\nserver: $s\n"
        ssh $s "cd $deploy_path/$component/namesrv; ./start-namesrv.sh"
    done
}

stop_name_servers()
{
    echo -e "\nname servers stop\n"
    for s in ${name_servers[@]}
    do
        echo -e "\nserver: $s\n"
        remote_kill $s org.apache.rocketmq.namesrv.NamesrvStartup
    done
}

start_brokers()
{
    echo -e "\nbroker servers start\n"
    for role in ${!broker_role_server_map[@]}
    do
        echo -e "\nserver: ${broker_role_server_map[$role]}, role: $role\n"
        ssh ${broker_role_server_map[$role]} "cd $deploy_path/$component/$role; \
            ./start-broker.sh; "
    done
}

stop_brokers()
{
    echo -e "\nbroker servers stop\n"
    brokers=(`merge_array ${broker_role_server_map[@]}`)
    for s in ${brokers[@]}
    do
        echo -e "\nserver: $s\n"
        remote_kill $s org.apache.rocketmq.broker.BrokerStartup
    done
}

batch_start()
{
    start_name_servers
    start_brokers
}

batch_stop()
{
    stop_brokers
    stop_name_servers
}

batch_status()
{
    echo -e "\nbroker servers status\n"
    brokers=(`merge_array ${broker_role_server_map[@]}`)
    for s in ${brokers[@]}
    do
        echo -e "\nserver: $s\n"
        remote_ps $s org.apache.rocketmq.broker.BrokerStartup
    done

    echo -e "\nname servers status\n"
    for s in ${name_servers[@]}
    do
        echo -e "\nserver: $s\n"
        remote_ps $s org.apache.rocketmq.namesrv.NamesrvStartup
    done
}
