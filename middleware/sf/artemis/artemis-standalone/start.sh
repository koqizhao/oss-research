#!/bin/bash

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

export SERVER_IP=`ip addr | grep "global enp0s8" | awk '{ print $2 }' | awk -F '/' '{ print $1 }'`

$JAVA_HOME/bin/java -Dserver.port=PORT \
    -Dhost.ip=$SERVER_IP \
    -Dserver.servlet.context-path=/artemis \
    -jar artemis.jar > LOG_DIR/artemis.out 2>&1 &
