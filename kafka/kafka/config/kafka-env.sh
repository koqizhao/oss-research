#!/bin/bash

host_ip=`ip addr | grep 192.168.56 | awk '{print $2}' | cut -f1 -d '/'`

#export CLASSPATH=$CLASSPATH:cp/:libs/*

export KAFKA_HEAP_OPTS="-Xms64m -Xmx512m"
export KAFKA_JVM_PERFORMANCE_OPTS="-XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -Djava.awt.headless=true -Djava.rmi.server.hostname=$host_ip"
export JMX_PORT=8302

