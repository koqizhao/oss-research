#!/bin/bash

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

$JAVA_HOME/bin/java -jar COMPONENT.jar > LOG_DIR/COMPONENT.out 2>&1 &
