#!/bin/bash

export SERVER_IP=`ip addr | grep "global enp0s8" | awk '{ print $2 }' | awk -F '/' '{ print $1 }'`

java -Dserver.port=8080 \
    -Deureka.instance.ip-address=$SERVER_IP \
    -jar eureka.jar > LOG_DIR/eureka.out 2>&1 &
