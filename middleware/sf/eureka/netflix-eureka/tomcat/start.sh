#!/bin/bash

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

export SERVER_IP=`ip addr | grep "global enp0s8" | awk '{ print $2 }' | awk -F '/' '{ print $1 }'`

#export CATALINA_OPTS="$CATALINA_OPTS -Dhost.ip=$SERVER_IP -Djava.net.preferIPv4Stack=true"

bin/catalina.sh run
