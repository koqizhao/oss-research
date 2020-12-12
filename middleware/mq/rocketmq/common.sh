#!/bin/bash

deploy_path=/home/koqizhao/middleware/mq/rocketmq

read_server_pass

namesrv_addr=""
for s in ${name_servers[@]}
do
    if [ -z "$namesrv_addr" ]; then
        namesrv_addr="$s:9876"
    else
        namesrv_addr="$namesrv_addr;$s:9876"
    fi
done
