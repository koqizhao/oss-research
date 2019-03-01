#!/bin/bash

export CLASSPATH=$CLASSPATH:ctrip-cp/:ctrip-libs/*
export KAFKA_HEAP_OPTS="-Xms64m -Xmx512m"
export KAFKA_JVM_PERFORMANCE_OPTS="-XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -Djava.awt.headless=true -Djava.rmi.server.hostname=192.168.56.102"
export JMX_PORT=8302

