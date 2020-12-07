#!/bin/bash

java -Drocketmq.namesrv.addr="NS_ADDRESS" \
    -Drocketmq.config.dataPath=DATA_DIR \
    -Dserver.port=8080 -jar DEPLOY_FILE \
    > rocketmq-console.out 2>&1 &
